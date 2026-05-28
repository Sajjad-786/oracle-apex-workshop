/*
================================================================================
  Workshop : Oracle APEX Workshop
  Chapter  : 04 – Authentication
  Script   : authentication_pkg_icons.sql
  Author   : Sajjad Hanifa
  Company  : S&H Software Solutions
  Website  : https://shsoftwaresolution.com
  Version  : 1.2.0
  Date     : 2026-05-28
================================================================================
  Change Log:
  v1.1.0 - Replaced DBMS_OBFUSCATION_TOOLKIT.MD5 with STANDARD_HASH (SHA256)
           MD5 via DBMS_OBFUSCATION_TOOLKIT is deprecated in Oracle 23c
  v1.2.0 - Removed pi_app_id parameter from pr_process_login
           APP_ID is now read internally via v('APP_ID')
================================================================================
*/

-- =============================================================================
-- PACKAGE SPECIFICATION
-- =============================================================================
CREATE OR REPLACE PACKAGE authentication
AS
    --------------------------------------------------------------------------------
    -- Function : fn_hash_pass
    -- Purpose  : Generate a deterministic password hash based on email and password.
    -- Notes    :
    --   - Email is part of the hash to prevent rainbow-table reuse
    --   - Uses SHA256 via STANDARD_HASH (Oracle 12c+)
    --   - Must be identical across DEV / TEST / PROD
    --------------------------------------------------------------------------------
    FUNCTION fn_hash_pass(
        pi_email            IN VARCHAR2 DEFAULT NULL
      , pi_password         IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    --------------------------------------------------------------------------------
    -- Function : fn_authenticate_user
    -- Purpose  : Authenticate user and validate company status.
    -- Notes    :
    --   - Sets P9999_LOGIN_MESSAGE on failure
    --   - Returns FALSE on any validation error
    --   - Returns TRUE only on full successful authentication
    --------------------------------------------------------------------------------
    FUNCTION fn_authenticate_user(
        pi_user_name        IN VARCHAR2
      , pi_password         IN VARCHAR2
    ) RETURN BOOLEAN;

    --------------------------------------------------------------------------------
    -- Procedure: pr_process_login
    -- Purpose  : Central login handler for Oracle APEX applications.
    -- Notes    :
    --   - Calls fn_authenticate_user for validation
    --   - On success: creates APEX session and redirects
    --   - On failure: session message already set by fn_authenticate_user
    --   - APP_ID is read internally via v('APP_ID') – no need to pass it as parameter
    --------------------------------------------------------------------------------
    PROCEDURE pr_process_login(
        pi_user_name        IN VARCHAR2
      , pi_password         IN VARCHAR2
    );

END authentication;
/


-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
create or replace PACKAGE BODY authentication
AS
    --------------------------------------------------------------------------------
    -- Function : fn_hash_pass
    --------------------------------------------------------------------------------
    FUNCTION fn_hash_pass(
        pi_email            IN VARCHAR2 DEFAULT NULL
      , pi_password         IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2
    IS
        v_hash_pass         VARCHAR2(4000);
        v_salt              VARCHAR2(4000)
            := 'hdjikndbbhitasuihfnnkqyhiplwmneuyndnloidj';
    BEGIN
        -- STANDARD_HASH is a SQL function, must be called via SELECT FROM DUAL in PL/SQL
        SELECT STANDARD_HASH(
                      pi_password
                   || SUBSTR(v_salt, 10, 13)
                   || LOWER(pi_email)
                   || SUBSTR(v_salt, 4, 10)
                 , 'SHA256'
               )
          INTO v_hash_pass
          FROM DUAL;

        RETURN v_hash_pass;
    END fn_hash_pass;

    --------------------------------------------------------------------------------
    -- Function : fn_authenticate_user
    --------------------------------------------------------------------------------
    FUNCTION fn_authenticate_user(
        pi_user_name        IN VARCHAR2
      , pi_password         IN VARCHAR2
    ) RETURN BOOLEAN
    IS
        v_password          VARCHAR2(4000);
        v_user_active_yn    VARCHAR2(4);
        v_user_deleted_yn   VARCHAR2(4);
        v_user_valid_from   TIMESTAMP;
        v_user_valid_to     TIMESTAMP;
        v_comp_active_yn    VARCHAR2(4);
        v_comp_deleted_yn   VARCHAR2(4);
        v_comp_valid_from   TIMESTAMP;
        v_comp_valid_to     TIMESTAMP;
    BEGIN
        ------------------------------------------------------------------------
        -- Input validation
        ------------------------------------------------------------------------
        IF TRIM(pi_user_name) IS NULL THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '📧 Please enter your email address!'
            );
            RETURN FALSE;
        END IF;

        IF TRIM(pi_password) IS NULL THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '🔑 Please enter your password!'
            );
            RETURN FALSE;
        END IF;

        ------------------------------------------------------------------------
        -- Fetch user + company in one query
        ------------------------------------------------------------------------
        BEGIN
            SELECT user_login_password
                 , user_active_yn
                 , user_deleted_yn
                 , user_valid_from
                 , user_valid_to
                 , comp_active_yn
                 , comp_deleted_yn
                 , comp_valid_from
                 , comp_valid_to
              INTO v_password
                 , v_user_active_yn
                 , v_user_deleted_yn
                 , v_user_valid_from
                 , v_user_valid_to
                 , v_comp_active_yn
                 , v_comp_deleted_yn
                 , v_comp_valid_from
                 , v_comp_valid_to
              FROM users
              JOIN companies ON comp_id = user_comp_fk
             WHERE LOWER(TRIM(user_login_email)) = LOWER(TRIM(pi_user_name))
            ;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                APEX_UTIL.Set_Session_State(
                    'LOGIN_MESSAGE'
                  , '🕵️ Login failed - please check your credentials!'
                );
                RETURN FALSE;
        END;

        ------------------------------------------------------------------------
        -- Password validation
        ------------------------------------------------------------------------
        IF v_password <> authentication.fn_hash_pass(
                             LOWER(TRIM(pi_user_name))
                           , pi_password
                         )
        THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '🔒 Login failed - please check your credentials!'
            );
            RETURN FALSE;
        END IF;

        ------------------------------------------------------------------------
        -- User status validations
        ------------------------------------------------------------------------
        IF v_user_deleted_yn = 'YES' THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '🚫 Your account has been permanently deactivated - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        IF v_user_active_yn <> 'YES' THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '⏸️ Your account is inactive - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        IF SYSDATE < v_user_valid_from THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '⏳ Your account is not yet active - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        IF SYSDATE > v_user_valid_to THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '⌛ Your account has expired - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        ------------------------------------------------------------------------
        -- Company status validations
        ------------------------------------------------------------------------
        IF v_comp_deleted_yn = 'YES' THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '🚫 Your company account has been permanently deactivated - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        IF v_comp_active_yn <> 'YES' THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '⏸️ Your company account is inactive - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        IF SYSDATE < v_comp_valid_from THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '⏳ Your company account is not yet active - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        IF SYSDATE > v_comp_valid_to THEN
            APEX_UTIL.Set_Session_State(
                'LOGIN_MESSAGE'
              , '⌛ Your company account has expired - please contact your administrator!'
            );
            RETURN FALSE;
        END IF;

        RETURN TRUE;

    END fn_authenticate_user;

    --------------------------------------------------------------------------------
    -- Procedure: pr_process_login
    --------------------------------------------------------------------------------
    PROCEDURE pr_process_login(
        pi_user_name        IN VARCHAR2
      , pi_password         IN VARCHAR2 
    )
    IS
        v_result            BOOLEAN;
        v_app_id            number := v('APP_ID');
    BEGIN
        v_result :=
            fn_authenticate_user(
                pi_user_name
              , pi_password
            );

        IF v_result THEN
            Wwv_Flow_Custom_Auth_Std.post_login(
                pi_user_name
              , pi_password
              , v('APP_SESSION')
              , v_app_id || ':1'
            );
        END IF;

    END pr_process_login;

END authentication;
/


