--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8 (Debian 12.8-1.pgdg100+1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


--
-- Name: client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


--
-- Name: client_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


--
-- Name: component; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


--
-- Name: component_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


--
-- Name: credential; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- Name: realm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode character varying(15) NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy character varying(20),
    logic character varying(20),
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


--
-- Name: user_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
4bfe2c85-d0d4-44ee-abc1-82938164fb22	\N	auth-cookie	27484249-b2b6-4f42-81db-28866ec26a77	6500200e-21ff-45c6-ab01-d459b2026079	2	10	f	\N	\N
7d6f1c0f-4d3f-43e5-9695-11b28350f0d3	\N	auth-spnego	27484249-b2b6-4f42-81db-28866ec26a77	6500200e-21ff-45c6-ab01-d459b2026079	3	20	f	\N	\N
dcd77c93-8ccf-47c7-b7e7-6a825f3c2dd0	\N	identity-provider-redirector	27484249-b2b6-4f42-81db-28866ec26a77	6500200e-21ff-45c6-ab01-d459b2026079	2	25	f	\N	\N
376c9466-2cf0-4b65-8521-640404c2cec4	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	6500200e-21ff-45c6-ab01-d459b2026079	2	30	t	5eb48f34-1c66-409f-bca6-06690f94fb9c	\N
33eb1d96-ae7c-4cc0-8e3a-2605744721bc	\N	auth-username-password-form	27484249-b2b6-4f42-81db-28866ec26a77	5eb48f34-1c66-409f-bca6-06690f94fb9c	0	10	f	\N	\N
35a7126a-f271-40e7-bca4-daec36461a59	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	5eb48f34-1c66-409f-bca6-06690f94fb9c	1	20	t	41efa924-ef39-40c1-8ccb-9b3d8423f9cd	\N
71b731e0-d09a-4ec7-9d69-a161bc9560b2	\N	conditional-user-configured	27484249-b2b6-4f42-81db-28866ec26a77	41efa924-ef39-40c1-8ccb-9b3d8423f9cd	0	10	f	\N	\N
80404dae-97d8-4d88-9dd4-19eb247c9f89	\N	auth-otp-form	27484249-b2b6-4f42-81db-28866ec26a77	41efa924-ef39-40c1-8ccb-9b3d8423f9cd	0	20	f	\N	\N
93a77f41-ddc6-4a27-9bd2-8f0f39b6a591	\N	direct-grant-validate-username	27484249-b2b6-4f42-81db-28866ec26a77	5dec0a8e-c880-4cf0-8a9f-5e3745f23241	0	10	f	\N	\N
c667ce47-ade9-41fd-8933-e555f0174581	\N	direct-grant-validate-password	27484249-b2b6-4f42-81db-28866ec26a77	5dec0a8e-c880-4cf0-8a9f-5e3745f23241	0	20	f	\N	\N
a644d605-94f6-4461-be1a-ae1e6c5dfc4a	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	5dec0a8e-c880-4cf0-8a9f-5e3745f23241	1	30	t	73de4d92-3daa-4a3b-95f8-082a53610f5e	\N
0ea605a8-bef3-4402-bf6e-1c36b2ec6ce5	\N	conditional-user-configured	27484249-b2b6-4f42-81db-28866ec26a77	73de4d92-3daa-4a3b-95f8-082a53610f5e	0	10	f	\N	\N
c39bd765-621b-441f-a2ce-8f9a2da0861e	\N	direct-grant-validate-otp	27484249-b2b6-4f42-81db-28866ec26a77	73de4d92-3daa-4a3b-95f8-082a53610f5e	0	20	f	\N	\N
d7a8fcd3-5959-4c7a-baa3-d0a0945182f0	\N	registration-page-form	27484249-b2b6-4f42-81db-28866ec26a77	224d7007-9a31-4bed-8e46-23463deb7f7d	0	10	t	1deeb31e-d5a1-4fd3-989f-7610ea8a853b	\N
edc4cfc2-35e4-4fbb-8515-a8b1c6e23fc2	\N	registration-user-creation	27484249-b2b6-4f42-81db-28866ec26a77	1deeb31e-d5a1-4fd3-989f-7610ea8a853b	0	20	f	\N	\N
bb600659-7815-4125-baf6-18df37e27c96	\N	registration-profile-action	27484249-b2b6-4f42-81db-28866ec26a77	1deeb31e-d5a1-4fd3-989f-7610ea8a853b	0	40	f	\N	\N
5807581c-32f5-47d4-ad8e-d0a4be22feea	\N	registration-password-action	27484249-b2b6-4f42-81db-28866ec26a77	1deeb31e-d5a1-4fd3-989f-7610ea8a853b	0	50	f	\N	\N
53c8c516-d439-40a2-9c5f-dcbd89313848	\N	registration-recaptcha-action	27484249-b2b6-4f42-81db-28866ec26a77	1deeb31e-d5a1-4fd3-989f-7610ea8a853b	3	60	f	\N	\N
0c9b3056-7614-47c2-a778-9f5d85baa5c9	\N	reset-credentials-choose-user	27484249-b2b6-4f42-81db-28866ec26a77	bcff79eb-6901-4676-a2ab-0a5c9dbc7daf	0	10	f	\N	\N
88db9a74-fca7-4f5f-abe7-1a87c9a89759	\N	reset-credential-email	27484249-b2b6-4f42-81db-28866ec26a77	bcff79eb-6901-4676-a2ab-0a5c9dbc7daf	0	20	f	\N	\N
9ccd40a3-bf88-41b5-a5d7-62320805e48a	\N	reset-password	27484249-b2b6-4f42-81db-28866ec26a77	bcff79eb-6901-4676-a2ab-0a5c9dbc7daf	0	30	f	\N	\N
3c4eb764-6c39-47d4-b9ea-7859068f3f8b	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	bcff79eb-6901-4676-a2ab-0a5c9dbc7daf	1	40	t	b2783873-a661-48b7-8440-38724dc5e756	\N
3442cba8-92dd-4458-9475-28eadfd11ab5	\N	conditional-user-configured	27484249-b2b6-4f42-81db-28866ec26a77	b2783873-a661-48b7-8440-38724dc5e756	0	10	f	\N	\N
eed68c9d-52bf-4b50-8f85-0f30afdb91fc	\N	reset-otp	27484249-b2b6-4f42-81db-28866ec26a77	b2783873-a661-48b7-8440-38724dc5e756	0	20	f	\N	\N
71399593-e5fe-4b76-8887-77980ed342b4	\N	client-secret	27484249-b2b6-4f42-81db-28866ec26a77	db6fdc30-6f9b-4003-a3db-4aee1c02639b	2	10	f	\N	\N
ff930791-1ceb-4bf1-90f1-2dd4ef3bc970	\N	client-jwt	27484249-b2b6-4f42-81db-28866ec26a77	db6fdc30-6f9b-4003-a3db-4aee1c02639b	2	20	f	\N	\N
a1173d59-f54d-43dc-8cc2-820109afb3d3	\N	client-secret-jwt	27484249-b2b6-4f42-81db-28866ec26a77	db6fdc30-6f9b-4003-a3db-4aee1c02639b	2	30	f	\N	\N
4509bd30-2d4c-4a5a-97e2-ed226ee87b14	\N	client-x509	27484249-b2b6-4f42-81db-28866ec26a77	db6fdc30-6f9b-4003-a3db-4aee1c02639b	2	40	f	\N	\N
1b71891d-d30e-4665-b438-7e5239dba4fe	\N	idp-review-profile	27484249-b2b6-4f42-81db-28866ec26a77	4e29fd3b-b49f-49d3-a7fc-ce9436e52d58	0	10	f	\N	cec54c26-7556-47dd-bc54-120fb060f3d5
e3420a44-85d3-4768-8f0b-56d8bb955f63	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	4e29fd3b-b49f-49d3-a7fc-ce9436e52d58	0	20	t	e5a6eb29-659b-42ca-bdc7-a85fa2461f0f	\N
da59b882-e826-40d3-b4ba-3cbd2ed7c20b	\N	idp-create-user-if-unique	27484249-b2b6-4f42-81db-28866ec26a77	e5a6eb29-659b-42ca-bdc7-a85fa2461f0f	2	10	f	\N	9b5396b8-6506-4acf-891f-6fdcfbab318e
0338fbe1-b33e-4d9f-83b5-10dfb38ea344	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	e5a6eb29-659b-42ca-bdc7-a85fa2461f0f	2	20	t	6821bccb-a5e7-4b01-9a52-6afa63dd6c5d	\N
7982411d-c02b-4c41-b41e-06eabfe7d8d6	\N	idp-confirm-link	27484249-b2b6-4f42-81db-28866ec26a77	6821bccb-a5e7-4b01-9a52-6afa63dd6c5d	0	10	f	\N	\N
e2222e3d-8795-4acd-b2bd-57d700050da8	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	6821bccb-a5e7-4b01-9a52-6afa63dd6c5d	0	20	t	d97665b5-ba00-4771-8313-8a5f4dd15a05	\N
a766a38e-c77c-4c34-8d1a-a95549e54f36	\N	idp-email-verification	27484249-b2b6-4f42-81db-28866ec26a77	d97665b5-ba00-4771-8313-8a5f4dd15a05	2	10	f	\N	\N
e11ea104-adc9-429a-b521-b1ee0597d770	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	d97665b5-ba00-4771-8313-8a5f4dd15a05	2	20	t	9aec2727-453f-479c-8fa5-72fbcf64fbfe	\N
e164f0fd-f210-492c-8e8c-89cc7653967b	\N	idp-username-password-form	27484249-b2b6-4f42-81db-28866ec26a77	9aec2727-453f-479c-8fa5-72fbcf64fbfe	0	10	f	\N	\N
dc0e7a03-9b83-4175-b8e8-9408688fe33c	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	9aec2727-453f-479c-8fa5-72fbcf64fbfe	1	20	t	2b3e8f2f-1870-4f6f-add1-4be1f130d90c	\N
08635c01-0bb5-4cdc-85fe-e6b6a603ded4	\N	conditional-user-configured	27484249-b2b6-4f42-81db-28866ec26a77	2b3e8f2f-1870-4f6f-add1-4be1f130d90c	0	10	f	\N	\N
97113420-5404-4b49-8e4d-be2b62a99488	\N	auth-otp-form	27484249-b2b6-4f42-81db-28866ec26a77	2b3e8f2f-1870-4f6f-add1-4be1f130d90c	0	20	f	\N	\N
b4012b43-3087-4adf-b308-827b32e33631	\N	http-basic-authenticator	27484249-b2b6-4f42-81db-28866ec26a77	7c35ec79-160d-4a40-a2a6-eb61782b33be	0	10	f	\N	\N
cf6e704b-be85-4514-96dd-305cede0e18f	\N	docker-http-basic-authenticator	27484249-b2b6-4f42-81db-28866ec26a77	8672d4fe-6f4a-4f7d-b596-ff37f3ab1b14	0	10	f	\N	\N
cb135f02-d8f1-48d4-9246-5986cec1aa05	\N	no-cookie-redirect	27484249-b2b6-4f42-81db-28866ec26a77	05186c9b-27bc-4142-bbe4-3ccf052f690a	0	10	f	\N	\N
4b6a6a9e-5209-4158-a33e-f281ba861253	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	05186c9b-27bc-4142-bbe4-3ccf052f690a	0	20	t	59abdeac-abcf-414d-b331-e747017cea8f	\N
de18d2a4-7ba8-44eb-aa9d-afcb57f334d9	\N	basic-auth	27484249-b2b6-4f42-81db-28866ec26a77	59abdeac-abcf-414d-b331-e747017cea8f	0	10	f	\N	\N
27263d04-75e5-42b6-977e-218b690ae76c	\N	basic-auth-otp	27484249-b2b6-4f42-81db-28866ec26a77	59abdeac-abcf-414d-b331-e747017cea8f	3	20	f	\N	\N
ca3fc2a8-5de8-4cbb-ba1e-f082948cccea	\N	auth-spnego	27484249-b2b6-4f42-81db-28866ec26a77	59abdeac-abcf-414d-b331-e747017cea8f	3	30	f	\N	\N
64daa023-b6fd-45a0-be4a-90d749631895	\N	idp-email-verification	esdl-mapeditor	742531d2-4237-4565-ac86-d3f9d0f58e6e	2	10	f	\N	\N
712c440c-7a12-4b16-9c4d-01b7a81d48c3	\N	\N	esdl-mapeditor	742531d2-4237-4565-ac86-d3f9d0f58e6e	2	20	t	97938f9b-7627-4682-8841-e5d2faf73ac0	\N
957da784-d6fb-4a6a-b993-54135ddee9bc	\N	basic-auth	esdl-mapeditor	55be635b-84b0-4e80-adaf-8b1464e40a72	0	10	f	\N	\N
9300dce6-b8c9-44dd-b55c-76cf3c756733	\N	basic-auth-otp	esdl-mapeditor	55be635b-84b0-4e80-adaf-8b1464e40a72	3	20	f	\N	\N
385f853b-49fb-4c14-b1d2-0208ea7b1f54	\N	auth-spnego	esdl-mapeditor	55be635b-84b0-4e80-adaf-8b1464e40a72	3	30	f	\N	\N
5dff1f6e-714e-40f0-a9fa-c945a13627dd	\N	conditional-user-configured	esdl-mapeditor	98341ac7-e61d-4bda-96a6-31c0ad0faebd	0	10	f	\N	\N
cb4a25ba-e2e5-463c-ae1c-999325322744	\N	auth-otp-form	esdl-mapeditor	98341ac7-e61d-4bda-96a6-31c0ad0faebd	0	20	f	\N	\N
e138a68d-65d7-47ac-a5d4-d230bd23f2d4	\N	conditional-user-configured	esdl-mapeditor	b10fec52-9a87-4de9-a00c-90fcf47493a4	0	10	f	\N	\N
60e4b7fe-efd6-4140-a1cd-aec1e347eca6	\N	direct-grant-validate-otp	esdl-mapeditor	b10fec52-9a87-4de9-a00c-90fcf47493a4	0	20	f	\N	\N
b70e6b41-c719-4782-bc50-c4929e4b2046	\N	conditional-user-configured	esdl-mapeditor	bb744cf7-b442-49fe-9483-1f2760fe1cfa	0	10	f	\N	\N
75d22afd-636d-46f6-a9ad-c05265ad827a	\N	auth-otp-form	esdl-mapeditor	bb744cf7-b442-49fe-9483-1f2760fe1cfa	0	20	f	\N	\N
8fda06d2-4577-4c6f-bf21-570c2e7833f6	\N	idp-confirm-link	esdl-mapeditor	79ae5713-d54b-445e-af08-2ac8a2affe66	0	10	f	\N	\N
f8c991dd-063a-4092-af65-6346c0c06d54	\N	\N	esdl-mapeditor	79ae5713-d54b-445e-af08-2ac8a2affe66	0	20	t	742531d2-4237-4565-ac86-d3f9d0f58e6e	\N
64065867-ea68-4ea8-95b4-b62f0fe39cb9	\N	conditional-user-configured	esdl-mapeditor	e0002aff-7b33-43cb-b736-2394d1fa3481	0	10	f	\N	\N
52d4754c-fa91-407e-9a6e-1e2c2636f953	\N	reset-otp	esdl-mapeditor	e0002aff-7b33-43cb-b736-2394d1fa3481	0	20	f	\N	\N
5f210954-eac5-4597-af4e-26e51879b71e	\N	idp-create-user-if-unique	esdl-mapeditor	41a76861-2474-4938-9435-65d80f18ba26	2	10	f	\N	41c6f90f-869b-483f-aafe-7f5702aa5d2b
48a8eb1e-530a-4868-9abf-08519582971d	\N	\N	esdl-mapeditor	41a76861-2474-4938-9435-65d80f18ba26	2	20	t	79ae5713-d54b-445e-af08-2ac8a2affe66	\N
21c6682f-4758-4e2f-88f7-56ec49707404	\N	idp-username-password-form	esdl-mapeditor	97938f9b-7627-4682-8841-e5d2faf73ac0	0	10	f	\N	\N
7c9653d4-f945-49cb-8b9c-104cb68a8954	\N	\N	esdl-mapeditor	97938f9b-7627-4682-8841-e5d2faf73ac0	1	20	t	bb744cf7-b442-49fe-9483-1f2760fe1cfa	\N
beaf704c-322f-48c8-8769-a2987791b4b8	\N	auth-cookie	esdl-mapeditor	1a3494ea-2fa2-4db2-8e5e-f098b0b5a745	2	10	f	\N	\N
1999057f-74f2-4d6e-b090-6433de9a40fe	\N	auth-spnego	esdl-mapeditor	1a3494ea-2fa2-4db2-8e5e-f098b0b5a745	3	20	f	\N	\N
2858012f-9947-47ad-b807-cfe775dc889d	\N	identity-provider-redirector	esdl-mapeditor	1a3494ea-2fa2-4db2-8e5e-f098b0b5a745	2	25	f	\N	\N
55c3327e-7239-4ae0-b6be-0944baf54109	\N	\N	esdl-mapeditor	1a3494ea-2fa2-4db2-8e5e-f098b0b5a745	2	30	t	ff2552ab-198c-4a21-8e6a-f80249e26f92	\N
e63842fb-79ac-4124-8fe4-07fbe77a87be	\N	client-secret	esdl-mapeditor	cee5f852-edd8-4e5d-9201-7b360518bab3	2	10	f	\N	\N
a26a04c0-872f-474d-8fcb-20e77196ece7	\N	client-jwt	esdl-mapeditor	cee5f852-edd8-4e5d-9201-7b360518bab3	2	20	f	\N	\N
a520342b-bab5-498c-9f69-20fa7214fd5d	\N	client-secret-jwt	esdl-mapeditor	cee5f852-edd8-4e5d-9201-7b360518bab3	2	30	f	\N	\N
3eadafeb-8a77-45e8-ada1-edd289bd461b	\N	client-x509	esdl-mapeditor	cee5f852-edd8-4e5d-9201-7b360518bab3	2	40	f	\N	\N
026b37a9-c5e1-4bfa-8730-df1873551ff5	\N	direct-grant-validate-username	esdl-mapeditor	7777b461-9a33-4cf6-8e3b-9f40ef295774	0	10	f	\N	\N
7edfa7ab-3748-4d9b-9447-f1cde55f6ffb	\N	direct-grant-validate-password	esdl-mapeditor	7777b461-9a33-4cf6-8e3b-9f40ef295774	0	20	f	\N	\N
e856e48c-2438-4e3c-a76e-6ad4c7a0780b	\N	\N	esdl-mapeditor	7777b461-9a33-4cf6-8e3b-9f40ef295774	1	30	t	b10fec52-9a87-4de9-a00c-90fcf47493a4	\N
57401928-f8c2-4b8b-9df4-8dc198154be0	\N	docker-http-basic-authenticator	esdl-mapeditor	f30a023f-6317-4b62-9c8c-6e6e5c88558d	0	10	f	\N	\N
434ed4fc-c443-4381-9cfc-dbd0c834b087	\N	idp-review-profile	esdl-mapeditor	6cbc3a6b-e17a-4121-aed3-4b2ec2a5f0b0	0	10	f	\N	cd8cbc57-63c0-4217-b52c-8a0957e1a190
2c80f409-2ae7-4384-8184-8e1415d64ee4	\N	\N	esdl-mapeditor	6cbc3a6b-e17a-4121-aed3-4b2ec2a5f0b0	0	20	t	41a76861-2474-4938-9435-65d80f18ba26	\N
90afd194-d82f-470d-ba62-60cf6645ceb1	\N	auth-username-password-form	esdl-mapeditor	ff2552ab-198c-4a21-8e6a-f80249e26f92	0	10	f	\N	\N
c1737745-bc30-42d0-a8a5-0988a7669806	\N	\N	esdl-mapeditor	ff2552ab-198c-4a21-8e6a-f80249e26f92	1	20	t	98341ac7-e61d-4bda-96a6-31c0ad0faebd	\N
20176588-5dbe-467e-a633-77f4efc6b449	\N	no-cookie-redirect	esdl-mapeditor	e8ad13dc-eec0-40bd-83ca-a6c72764af43	0	10	f	\N	\N
3909d195-dde3-462b-9e1f-30124c3ec37b	\N	\N	esdl-mapeditor	e8ad13dc-eec0-40bd-83ca-a6c72764af43	0	20	t	55be635b-84b0-4e80-adaf-8b1464e40a72	\N
6660bfda-42cf-489d-b72a-7945e4c7eaeb	\N	registration-page-form	esdl-mapeditor	2cbfcaff-1611-4885-8690-f66301590060	0	10	t	5d97e4f3-1f86-4a59-8dea-72b6a8444c5a	\N
b719d92d-a3a2-4ef0-a8f6-34dab4afb6cd	\N	registration-user-creation	esdl-mapeditor	5d97e4f3-1f86-4a59-8dea-72b6a8444c5a	0	20	f	\N	\N
a1cdccbf-3e07-47d1-9f1a-280a71b7f0b1	\N	registration-profile-action	esdl-mapeditor	5d97e4f3-1f86-4a59-8dea-72b6a8444c5a	0	40	f	\N	\N
1918e7d4-e1e2-4bae-b364-55dd995422a1	\N	registration-password-action	esdl-mapeditor	5d97e4f3-1f86-4a59-8dea-72b6a8444c5a	0	50	f	\N	\N
51666bea-4c76-4284-9099-8d6b3178443b	\N	registration-recaptcha-action	esdl-mapeditor	5d97e4f3-1f86-4a59-8dea-72b6a8444c5a	3	60	f	\N	\N
2d56de59-1b91-452c-9340-3d366db62905	\N	reset-credentials-choose-user	esdl-mapeditor	76239c04-5887-4a49-994d-cd4e09c48e9b	0	10	f	\N	\N
57bc336e-f60d-4c1c-9b0b-8c41a93d2716	\N	reset-credential-email	esdl-mapeditor	76239c04-5887-4a49-994d-cd4e09c48e9b	0	20	f	\N	\N
f45dc7aa-bf38-4868-be73-3f7a94ebc8c0	\N	reset-password	esdl-mapeditor	76239c04-5887-4a49-994d-cd4e09c48e9b	0	30	f	\N	\N
16bf4525-7b1f-4b6b-a3de-386721688a7a	\N	\N	esdl-mapeditor	76239c04-5887-4a49-994d-cd4e09c48e9b	1	40	t	e0002aff-7b33-43cb-b736-2394d1fa3481	\N
f4e02915-b9b1-4d3d-9167-1bf240b68fb8	\N	http-basic-authenticator	esdl-mapeditor	18b95388-9024-4b4d-9e9e-86865b3e2aba	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
6500200e-21ff-45c6-ab01-d459b2026079	browser	browser based authentication	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
5eb48f34-1c66-409f-bca6-06690f94fb9c	forms	Username, password, otp and other auth forms.	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
41efa924-ef39-40c1-8ccb-9b3d8423f9cd	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
5dec0a8e-c880-4cf0-8a9f-5e3745f23241	direct grant	OpenID Connect Resource Owner Grant	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
73de4d92-3daa-4a3b-95f8-082a53610f5e	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
224d7007-9a31-4bed-8e46-23463deb7f7d	registration	registration flow	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
1deeb31e-d5a1-4fd3-989f-7610ea8a853b	registration form	registration form	27484249-b2b6-4f42-81db-28866ec26a77	form-flow	f	t
bcff79eb-6901-4676-a2ab-0a5c9dbc7daf	reset credentials	Reset credentials for a user if they forgot their password or something	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
b2783873-a661-48b7-8440-38724dc5e756	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
db6fdc30-6f9b-4003-a3db-4aee1c02639b	clients	Base authentication for clients	27484249-b2b6-4f42-81db-28866ec26a77	client-flow	t	t
4e29fd3b-b49f-49d3-a7fc-ce9436e52d58	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
e5a6eb29-659b-42ca-bdc7-a85fa2461f0f	User creation or linking	Flow for the existing/non-existing user alternatives	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
6821bccb-a5e7-4b01-9a52-6afa63dd6c5d	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
d97665b5-ba00-4771-8313-8a5f4dd15a05	Account verification options	Method with which to verity the existing account	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
9aec2727-453f-479c-8fa5-72fbcf64fbfe	Verify Existing Account by Re-authentication	Reauthentication of existing account	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
2b3e8f2f-1870-4f6f-add1-4be1f130d90c	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
7c35ec79-160d-4a40-a2a6-eb61782b33be	saml ecp	SAML ECP Profile Authentication Flow	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
8672d4fe-6f4a-4f7d-b596-ff37f3ab1b14	docker auth	Used by Docker clients to authenticate against the IDP	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
05186c9b-27bc-4142-bbe4-3ccf052f690a	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	t	t
59abdeac-abcf-414d-b331-e747017cea8f	Authentication Options	Authentication options.	27484249-b2b6-4f42-81db-28866ec26a77	basic-flow	f	t
742531d2-4237-4565-ac86-d3f9d0f58e6e	Account verification options	Method with which to verity the existing account	esdl-mapeditor	basic-flow	f	t
55be635b-84b0-4e80-adaf-8b1464e40a72	Authentication Options	Authentication options.	esdl-mapeditor	basic-flow	f	t
98341ac7-e61d-4bda-96a6-31c0ad0faebd	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	esdl-mapeditor	basic-flow	f	t
b10fec52-9a87-4de9-a00c-90fcf47493a4	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	esdl-mapeditor	basic-flow	f	t
bb744cf7-b442-49fe-9483-1f2760fe1cfa	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	esdl-mapeditor	basic-flow	f	t
79ae5713-d54b-445e-af08-2ac8a2affe66	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	esdl-mapeditor	basic-flow	f	t
e0002aff-7b33-43cb-b736-2394d1fa3481	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	esdl-mapeditor	basic-flow	f	t
41a76861-2474-4938-9435-65d80f18ba26	User creation or linking	Flow for the existing/non-existing user alternatives	esdl-mapeditor	basic-flow	f	t
97938f9b-7627-4682-8841-e5d2faf73ac0	Verify Existing Account by Re-authentication	Reauthentication of existing account	esdl-mapeditor	basic-flow	f	t
1a3494ea-2fa2-4db2-8e5e-f098b0b5a745	browser	browser based authentication	esdl-mapeditor	basic-flow	t	t
cee5f852-edd8-4e5d-9201-7b360518bab3	clients	Base authentication for clients	esdl-mapeditor	client-flow	t	t
7777b461-9a33-4cf6-8e3b-9f40ef295774	direct grant	OpenID Connect Resource Owner Grant	esdl-mapeditor	basic-flow	t	t
f30a023f-6317-4b62-9c8c-6e6e5c88558d	docker auth	Used by Docker clients to authenticate against the IDP	esdl-mapeditor	basic-flow	t	t
6cbc3a6b-e17a-4121-aed3-4b2ec2a5f0b0	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	esdl-mapeditor	basic-flow	t	t
ff2552ab-198c-4a21-8e6a-f80249e26f92	forms	Username, password, otp and other auth forms.	esdl-mapeditor	basic-flow	f	t
e8ad13dc-eec0-40bd-83ca-a6c72764af43	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	esdl-mapeditor	basic-flow	t	t
2cbfcaff-1611-4885-8690-f66301590060	registration	registration flow	esdl-mapeditor	basic-flow	t	t
5d97e4f3-1f86-4a59-8dea-72b6a8444c5a	registration form	registration form	esdl-mapeditor	form-flow	f	t
76239c04-5887-4a49-994d-cd4e09c48e9b	reset credentials	Reset credentials for a user if they forgot their password or something	esdl-mapeditor	basic-flow	t	t
18b95388-9024-4b4d-9e9e-86865b3e2aba	saml ecp	SAML ECP Profile Authentication Flow	esdl-mapeditor	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
cec54c26-7556-47dd-bc54-120fb060f3d5	review profile config	27484249-b2b6-4f42-81db-28866ec26a77
9b5396b8-6506-4acf-891f-6fdcfbab318e	create unique user config	27484249-b2b6-4f42-81db-28866ec26a77
41c6f90f-869b-483f-aafe-7f5702aa5d2b	create unique user config	esdl-mapeditor
cd8cbc57-63c0-4217-b52c-8a0957e1a190	review profile config	esdl-mapeditor
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
9b5396b8-6506-4acf-891f-6fdcfbab318e	false	require.password.update.after.registration
cec54c26-7556-47dd-bc54-120fb060f3d5	missing	update.profile.on.first.login
41c6f90f-869b-483f-aafe-7f5702aa5d2b	false	require.password.update.after.registration
cd8cbc57-63c0-4217-b52c-8a0957e1a190	missing	update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
d8c1eb85-609a-4124-a680-2004c04d18a8	t	f	master-realm	0	f	\N	\N	t	\N	f	27484249-b2b6-4f42-81db-28866ec26a77	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	27484249-b2b6-4f42-81db-28866ec26a77	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
3685fc1f-d0a1-488f-b4b6-6085c430766a	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	27484249-b2b6-4f42-81db-28866ec26a77	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
3d2181fc-5614-4fcb-831a-4180804c229b	t	f	broker	0	f	\N	\N	t	\N	f	27484249-b2b6-4f42-81db-28866ec26a77	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
98188f0b-9771-4045-a9d2-36e13ad07ec6	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	27484249-b2b6-4f42-81db-28866ec26a77	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
57ad52de-22b6-4da1-9a5c-f9c2107704a8	t	f	admin-cli	0	t	\N	\N	f	\N	f	27484249-b2b6-4f42-81db-28866ec26a77	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	f	esdl-mapeditor-realm	0	f	\N	\N	t	\N	f	27484249-b2b6-4f42-81db-28866ec26a77	\N	0	f	f	esdl-mapeditor Realm	f	client-secret	\N	\N	\N	t	f	f	f
043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	f	account	0	f	dbb2a770-51be-4644-9c98-cc6d0af81d31	/realms/esdl-mapeditor/account/	f	\N	f	esdl-mapeditor	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
295b1d84-f59f-4336-b864-6fb3cf140de1	t	f	account-console	0	t	f63c796d-e6a6-42bf-85ed-cc13d7d0a0a5	/realms/esdl-mapeditor/account/	f	\N	f	esdl-mapeditor	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
9f6e8285-b738-4e25-b398-bff3211164ee	t	f	admin-cli	0	t	d67f86b9-7cc4-4522-b0f1-2d4b506aa9a8	\N	f	\N	f	esdl-mapeditor	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
a81afdbf-f130-4f26-bafd-73e08372e558	t	f	broker	0	f	1fea6a9a-e8ac-46aa-8044-3a3ce113f7f2	\N	f	\N	f	esdl-mapeditor	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
c335a38b-9f6c-4256-bc10-43561bb80698	t	t	cdo-mondaine	0	f	329ab44b-087b-44d2-89b7-da139d32a7b1	http://localhost:9080/	f	http://esdl-drive:9080/*	f	esdl-mapeditor	openid-connect	-1	f	f	CDO-based Mondaine storage server	t	client-secret	http://localhost:9080/*	\N	\N	t	f	t	f
d831b9b7-10f6-45d1-ab10-621ff861dd5b	t	t	curl	0	t	6f8d0fbe-e714-47c6-882b-bdef71d81885	\N	f	\N	f	esdl-mapeditor	openid-connect	-1	f	f	Allow commandline tools to access ESDL Drive	f	client-secret	\N	Allow curl and the esdl-drive commandline tool to query resources in this realm e.g. using Direct Access Grants	\N	f	f	t	f
4d2874c8-1177-4cd4-991f-9a62ce88db03	t	t	esdl-mapeditor	0	f	623324ba-0bfa-4798-820f-7f461cbc7839		f		f	esdl-mapeditor	openid-connect	-1	f	f	ESDL Map Editor Client	t	client-secret	http://localhost:8111	\N	\N	t	f	t	f
603d98fb-fd82-446a-aec4-03abc7a0ebd4	t	t	essim-dashboard	0	f	174522fe-db1c-4384-a3c5-eaa6dc03329b	\N	f	http://localhost:3000	f	esdl-mapeditor	openid-connect	-1	f	f	\N	t	client-secret	http://localhost:3000	\N	\N	t	f	t	f
0eb5ebad-abba-4f01-b2af-56c4874059c4	t	f	realm-management	0	f	090d2aed-0141-4b66-bd46-e1500686a17b	\N	t	\N	f	esdl-mapeditor	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
ee1eff39-a727-46a3-9d18-0600e356d847	t	f	security-admin-console	0	t	733872de-e75c-4b17-896f-ca4f854dd028	/admin/esdl-mapeditor/console/	f	\N	f	esdl-mapeditor	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	post.logout.redirect.uris	+
3685fc1f-d0a1-488f-b4b6-6085c430766a	post.logout.redirect.uris	+
3685fc1f-d0a1-488f-b4b6-6085c430766a	pkce.code.challenge.method	S256
98188f0b-9771-4045-a9d2-36e13ad07ec6	post.logout.redirect.uris	+
98188f0b-9771-4045-a9d2-36e13ad07ec6	pkce.code.challenge.method	S256
043f3b1d-595d-4fe1-b984-7fc13582cdf2	post.logout.redirect.uris	+
295b1d84-f59f-4336-b864-6fb3cf140de1	pkce.code.challenge.method	S256
295b1d84-f59f-4336-b864-6fb3cf140de1	post.logout.redirect.uris	+
9f6e8285-b738-4e25-b398-bff3211164ee	post.logout.redirect.uris	+
a81afdbf-f130-4f26-bafd-73e08372e558	post.logout.redirect.uris	+
c335a38b-9f6c-4256-bc10-43561bb80698	saml.assertion.signature	false
c335a38b-9f6c-4256-bc10-43561bb80698	saml.multivalued.roles	false
c335a38b-9f6c-4256-bc10-43561bb80698	saml.force.post.binding	false
c335a38b-9f6c-4256-bc10-43561bb80698	saml.encrypt	false
c335a38b-9f6c-4256-bc10-43561bb80698	access.token.signed.response.alg	RS256
c335a38b-9f6c-4256-bc10-43561bb80698	saml.server.signature	false
c335a38b-9f6c-4256-bc10-43561bb80698	saml.server.signature.keyinfo.ext	false
c335a38b-9f6c-4256-bc10-43561bb80698	exclude.session.state.from.auth.response	false
c335a38b-9f6c-4256-bc10-43561bb80698	id.token.signed.response.alg	RS256
c335a38b-9f6c-4256-bc10-43561bb80698	saml_force_name_id_format	false
c335a38b-9f6c-4256-bc10-43561bb80698	saml.client.signature	false
c335a38b-9f6c-4256-bc10-43561bb80698	tls.client.certificate.bound.access.tokens	false
c335a38b-9f6c-4256-bc10-43561bb80698	saml.authnstatement	false
c335a38b-9f6c-4256-bc10-43561bb80698	display.on.consent.screen	false
c335a38b-9f6c-4256-bc10-43561bb80698	saml.onetimeuse.condition	false
c335a38b-9f6c-4256-bc10-43561bb80698	post.logout.redirect.uris	+
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.assertion.signature	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.multivalued.roles	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.force.post.binding	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.encrypt	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.server.signature	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.server.signature.keyinfo.ext	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	exclude.session.state.from.auth.response	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml_force_name_id_format	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.client.signature	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	tls.client.certificate.bound.access.tokens	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.authnstatement	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	display.on.consent.screen	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	saml.onetimeuse.condition	false
d831b9b7-10f6-45d1-ab10-621ff861dd5b	post.logout.redirect.uris	+
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.assertion.signature	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.multivalued.roles	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.force.post.binding	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.encrypt	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	login_theme	keycloak
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.server.signature	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.server.signature.keyinfo.ext	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	exclude.session.state.from.auth.response	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml_force_name_id_format	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.client.signature	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	tls.client.certificate.bound.access.tokens	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.authnstatement	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	display.on.consent.screen	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	saml.onetimeuse.condition	false
4d2874c8-1177-4cd4-991f-9a62ce88db03	post.logout.redirect.uris	+
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.assertion.signature	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.multivalued.roles	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.force.post.binding	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.encrypt	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.server.signature	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.server.signature.keyinfo.ext	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	exclude.session.state.from.auth.response	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml_force_name_id_format	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.client.signature	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	tls.client.certificate.bound.access.tokens	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.authnstatement	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	display.on.consent.screen	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	saml.onetimeuse.condition	false
603d98fb-fd82-446a-aec4-03abc7a0ebd4	post.logout.redirect.uris	+
0eb5ebad-abba-4f01-b2af-56c4874059c4	post.logout.redirect.uris	+
ee1eff39-a727-46a3-9d18-0600e356d847	pkce.code.challenge.method	S256
ee1eff39-a727-46a3-9d18-0600e356d847	post.logout.redirect.uris	+
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
012c4282-5f36-4291-a5b9-26a02853d775	offline_access	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect built-in scope: offline_access	openid-connect
1dd78784-ba97-4215-841c-4d8c1af20d90	role_list	27484249-b2b6-4f42-81db-28866ec26a77	SAML role list	saml
21dabfb9-9365-486a-bf49-19a04aeec692	profile	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect built-in scope: profile	openid-connect
1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	email	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect built-in scope: email	openid-connect
29733772-4947-4728-9a12-e9b2de3bd0a5	address	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect built-in scope: address	openid-connect
a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	phone	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect built-in scope: phone	openid-connect
6879185d-004e-4aa7-827b-bcdc525be1eb	roles	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect scope for add user roles to the access token	openid-connect
98855351-a294-4d1b-89f3-149c9c5fe267	web-origins	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect scope for add allowed web origins to the access token	openid-connect
22df6a73-be77-4043-bf2c-b9ede06836c1	microprofile-jwt	27484249-b2b6-4f42-81db-28866ec26a77	Microprofile - JWT built-in scope	openid-connect
64ca43a1-5da9-4054-9884-2bd5cfa2dd09	acr	27484249-b2b6-4f42-81db-28866ec26a77	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
2cd84421-3e0f-44ed-bce3-f365cb6ecaf2	role_list	esdl-mapeditor	SAML role list	saml
fbec02ac-b60d-4ee8-86dd-ddac69aefe31	user_group_path	esdl-mapeditor	Add user's group to the ID token including the hierarchy of the group	openid-connect
5d8dec81-b910-47d0-93ff-c7cd4f714eda	esdl-mapeditor	esdl-mapeditor	ESDL map editor client scope	openid-connect
a238a12d-c366-4492-8d87-1915dedd0b64	groups	esdl-mapeditor	Maps user realm roles to the groups claim	openid-connect
62e93726-e7be-4ff2-a8a0-427cb842cb09	offline_access	esdl-mapeditor	OpenID Connect built-in scope: offline_access	openid-connect
b29d72c1-0d0b-44b6-935f-247cb70b4f93	profile	esdl-mapeditor	OpenID Connect built-in scope: profile	openid-connect
71641c61-88c7-421b-82c9-174a0e663347	email	esdl-mapeditor	OpenID Connect built-in scope: email	openid-connect
42b21bf0-65df-4390-a003-c4f51bf006a3	address	esdl-mapeditor	OpenID Connect built-in scope: address	openid-connect
d8105fab-c29b-42fb-9130-bd3062d87bc1	phone	esdl-mapeditor	OpenID Connect built-in scope: phone	openid-connect
eb4d7ce7-7ae6-4597-a384-ebcf870ad658	roles	esdl-mapeditor	OpenID Connect scope for add user roles to the access token	openid-connect
92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	web-origins	esdl-mapeditor	OpenID Connect scope for add allowed web origins to the access token	openid-connect
1e13f30e-663f-4409-874c-c2fdcab59306	microprofile-jwt	esdl-mapeditor	Microprofile - JWT built-in scope	openid-connect
338168d6-6070-48f0-8c7b-b7d02089305f	user_group	esdl-mapeditor	Show groups a user belongs to	openid-connect
0636469e-a1fe-448c-83ee-9d5e5a67c392	essim	esdl-mapeditor	Access to essim	openid-connect
943b3db3-8ed4-420f-954c-3ea6e596a4c1	acr	esdl-mapeditor	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
012c4282-5f36-4291-a5b9-26a02853d775	true	display.on.consent.screen
012c4282-5f36-4291-a5b9-26a02853d775	${offlineAccessScopeConsentText}	consent.screen.text
1dd78784-ba97-4215-841c-4d8c1af20d90	true	display.on.consent.screen
1dd78784-ba97-4215-841c-4d8c1af20d90	${samlRoleListScopeConsentText}	consent.screen.text
21dabfb9-9365-486a-bf49-19a04aeec692	true	display.on.consent.screen
21dabfb9-9365-486a-bf49-19a04aeec692	${profileScopeConsentText}	consent.screen.text
21dabfb9-9365-486a-bf49-19a04aeec692	true	include.in.token.scope
1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	true	display.on.consent.screen
1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	${emailScopeConsentText}	consent.screen.text
1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	true	include.in.token.scope
29733772-4947-4728-9a12-e9b2de3bd0a5	true	display.on.consent.screen
29733772-4947-4728-9a12-e9b2de3bd0a5	${addressScopeConsentText}	consent.screen.text
29733772-4947-4728-9a12-e9b2de3bd0a5	true	include.in.token.scope
a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	true	display.on.consent.screen
a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	${phoneScopeConsentText}	consent.screen.text
a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	true	include.in.token.scope
6879185d-004e-4aa7-827b-bcdc525be1eb	true	display.on.consent.screen
6879185d-004e-4aa7-827b-bcdc525be1eb	${rolesScopeConsentText}	consent.screen.text
6879185d-004e-4aa7-827b-bcdc525be1eb	false	include.in.token.scope
98855351-a294-4d1b-89f3-149c9c5fe267	false	display.on.consent.screen
98855351-a294-4d1b-89f3-149c9c5fe267		consent.screen.text
98855351-a294-4d1b-89f3-149c9c5fe267	false	include.in.token.scope
22df6a73-be77-4043-bf2c-b9ede06836c1	false	display.on.consent.screen
22df6a73-be77-4043-bf2c-b9ede06836c1	true	include.in.token.scope
64ca43a1-5da9-4054-9884-2bd5cfa2dd09	false	display.on.consent.screen
64ca43a1-5da9-4054-9884-2bd5cfa2dd09	false	include.in.token.scope
2cd84421-3e0f-44ed-bce3-f365cb6ecaf2	${samlRoleListScopeConsentText}	consent.screen.text
2cd84421-3e0f-44ed-bce3-f365cb6ecaf2	true	display.on.consent.screen
fbec02ac-b60d-4ee8-86dd-ddac69aefe31	true	include.in.token.scope
fbec02ac-b60d-4ee8-86dd-ddac69aefe31	true	display.on.consent.screen
5d8dec81-b910-47d0-93ff-c7cd4f714eda	true	include.in.token.scope
5d8dec81-b910-47d0-93ff-c7cd4f714eda	true	display.on.consent.screen
a238a12d-c366-4492-8d87-1915dedd0b64	true	include.in.token.scope
a238a12d-c366-4492-8d87-1915dedd0b64	true	display.on.consent.screen
62e93726-e7be-4ff2-a8a0-427cb842cb09	${offlineAccessScopeConsentText}	consent.screen.text
62e93726-e7be-4ff2-a8a0-427cb842cb09	true	display.on.consent.screen
b29d72c1-0d0b-44b6-935f-247cb70b4f93	true	include.in.token.scope
b29d72c1-0d0b-44b6-935f-247cb70b4f93	true	display.on.consent.screen
b29d72c1-0d0b-44b6-935f-247cb70b4f93	${profileScopeConsentText}	consent.screen.text
71641c61-88c7-421b-82c9-174a0e663347	true	include.in.token.scope
71641c61-88c7-421b-82c9-174a0e663347	true	display.on.consent.screen
71641c61-88c7-421b-82c9-174a0e663347	${emailScopeConsentText}	consent.screen.text
42b21bf0-65df-4390-a003-c4f51bf006a3	true	include.in.token.scope
42b21bf0-65df-4390-a003-c4f51bf006a3	true	display.on.consent.screen
42b21bf0-65df-4390-a003-c4f51bf006a3	${addressScopeConsentText}	consent.screen.text
d8105fab-c29b-42fb-9130-bd3062d87bc1	true	include.in.token.scope
d8105fab-c29b-42fb-9130-bd3062d87bc1	true	display.on.consent.screen
d8105fab-c29b-42fb-9130-bd3062d87bc1	${phoneScopeConsentText}	consent.screen.text
eb4d7ce7-7ae6-4597-a384-ebcf870ad658	false	include.in.token.scope
eb4d7ce7-7ae6-4597-a384-ebcf870ad658	true	display.on.consent.screen
eb4d7ce7-7ae6-4597-a384-ebcf870ad658	${rolesScopeConsentText}	consent.screen.text
92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	false	include.in.token.scope
92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	false	display.on.consent.screen
92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2		consent.screen.text
1e13f30e-663f-4409-874c-c2fdcab59306	true	include.in.token.scope
1e13f30e-663f-4409-874c-c2fdcab59306	false	display.on.consent.screen
338168d6-6070-48f0-8c7b-b7d02089305f	true	include.in.token.scope
338168d6-6070-48f0-8c7b-b7d02089305f	true	display.on.consent.screen
0636469e-a1fe-448c-83ee-9d5e5a67c392	true	include.in.token.scope
0636469e-a1fe-448c-83ee-9d5e5a67c392	true	display.on.consent.screen
943b3db3-8ed4-420f-954c-3ea6e596a4c1	false	display.on.consent.screen
943b3db3-8ed4-420f-954c-3ea6e596a4c1	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	21dabfb9-9365-486a-bf49-19a04aeec692	t
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	6879185d-004e-4aa7-827b-bcdc525be1eb	t
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	98855351-a294-4d1b-89f3-149c9c5fe267	t
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	64ca43a1-5da9-4054-9884-2bd5cfa2dd09	t
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	t
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	22df6a73-be77-4043-bf2c-b9ede06836c1	f
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	f
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	012c4282-5f36-4291-a5b9-26a02853d775	f
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	29733772-4947-4728-9a12-e9b2de3bd0a5	f
3685fc1f-d0a1-488f-b4b6-6085c430766a	21dabfb9-9365-486a-bf49-19a04aeec692	t
3685fc1f-d0a1-488f-b4b6-6085c430766a	6879185d-004e-4aa7-827b-bcdc525be1eb	t
3685fc1f-d0a1-488f-b4b6-6085c430766a	98855351-a294-4d1b-89f3-149c9c5fe267	t
3685fc1f-d0a1-488f-b4b6-6085c430766a	64ca43a1-5da9-4054-9884-2bd5cfa2dd09	t
3685fc1f-d0a1-488f-b4b6-6085c430766a	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	t
3685fc1f-d0a1-488f-b4b6-6085c430766a	22df6a73-be77-4043-bf2c-b9ede06836c1	f
3685fc1f-d0a1-488f-b4b6-6085c430766a	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	f
3685fc1f-d0a1-488f-b4b6-6085c430766a	012c4282-5f36-4291-a5b9-26a02853d775	f
3685fc1f-d0a1-488f-b4b6-6085c430766a	29733772-4947-4728-9a12-e9b2de3bd0a5	f
57ad52de-22b6-4da1-9a5c-f9c2107704a8	21dabfb9-9365-486a-bf49-19a04aeec692	t
57ad52de-22b6-4da1-9a5c-f9c2107704a8	6879185d-004e-4aa7-827b-bcdc525be1eb	t
57ad52de-22b6-4da1-9a5c-f9c2107704a8	98855351-a294-4d1b-89f3-149c9c5fe267	t
57ad52de-22b6-4da1-9a5c-f9c2107704a8	64ca43a1-5da9-4054-9884-2bd5cfa2dd09	t
57ad52de-22b6-4da1-9a5c-f9c2107704a8	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	t
57ad52de-22b6-4da1-9a5c-f9c2107704a8	22df6a73-be77-4043-bf2c-b9ede06836c1	f
57ad52de-22b6-4da1-9a5c-f9c2107704a8	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	f
57ad52de-22b6-4da1-9a5c-f9c2107704a8	012c4282-5f36-4291-a5b9-26a02853d775	f
57ad52de-22b6-4da1-9a5c-f9c2107704a8	29733772-4947-4728-9a12-e9b2de3bd0a5	f
3d2181fc-5614-4fcb-831a-4180804c229b	21dabfb9-9365-486a-bf49-19a04aeec692	t
3d2181fc-5614-4fcb-831a-4180804c229b	6879185d-004e-4aa7-827b-bcdc525be1eb	t
3d2181fc-5614-4fcb-831a-4180804c229b	98855351-a294-4d1b-89f3-149c9c5fe267	t
3d2181fc-5614-4fcb-831a-4180804c229b	64ca43a1-5da9-4054-9884-2bd5cfa2dd09	t
3d2181fc-5614-4fcb-831a-4180804c229b	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	t
3d2181fc-5614-4fcb-831a-4180804c229b	22df6a73-be77-4043-bf2c-b9ede06836c1	f
3d2181fc-5614-4fcb-831a-4180804c229b	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	f
3d2181fc-5614-4fcb-831a-4180804c229b	012c4282-5f36-4291-a5b9-26a02853d775	f
3d2181fc-5614-4fcb-831a-4180804c229b	29733772-4947-4728-9a12-e9b2de3bd0a5	f
d8c1eb85-609a-4124-a680-2004c04d18a8	21dabfb9-9365-486a-bf49-19a04aeec692	t
d8c1eb85-609a-4124-a680-2004c04d18a8	6879185d-004e-4aa7-827b-bcdc525be1eb	t
d8c1eb85-609a-4124-a680-2004c04d18a8	98855351-a294-4d1b-89f3-149c9c5fe267	t
d8c1eb85-609a-4124-a680-2004c04d18a8	64ca43a1-5da9-4054-9884-2bd5cfa2dd09	t
d8c1eb85-609a-4124-a680-2004c04d18a8	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	t
d8c1eb85-609a-4124-a680-2004c04d18a8	22df6a73-be77-4043-bf2c-b9ede06836c1	f
d8c1eb85-609a-4124-a680-2004c04d18a8	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	f
d8c1eb85-609a-4124-a680-2004c04d18a8	012c4282-5f36-4291-a5b9-26a02853d775	f
d8c1eb85-609a-4124-a680-2004c04d18a8	29733772-4947-4728-9a12-e9b2de3bd0a5	f
98188f0b-9771-4045-a9d2-36e13ad07ec6	21dabfb9-9365-486a-bf49-19a04aeec692	t
98188f0b-9771-4045-a9d2-36e13ad07ec6	6879185d-004e-4aa7-827b-bcdc525be1eb	t
98188f0b-9771-4045-a9d2-36e13ad07ec6	98855351-a294-4d1b-89f3-149c9c5fe267	t
98188f0b-9771-4045-a9d2-36e13ad07ec6	64ca43a1-5da9-4054-9884-2bd5cfa2dd09	t
98188f0b-9771-4045-a9d2-36e13ad07ec6	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	t
98188f0b-9771-4045-a9d2-36e13ad07ec6	22df6a73-be77-4043-bf2c-b9ede06836c1	f
98188f0b-9771-4045-a9d2-36e13ad07ec6	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	f
98188f0b-9771-4045-a9d2-36e13ad07ec6	012c4282-5f36-4291-a5b9-26a02853d775	f
98188f0b-9771-4045-a9d2-36e13ad07ec6	29733772-4947-4728-9a12-e9b2de3bd0a5	f
043f3b1d-595d-4fe1-b984-7fc13582cdf2	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
043f3b1d-595d-4fe1-b984-7fc13582cdf2	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
043f3b1d-595d-4fe1-b984-7fc13582cdf2	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
043f3b1d-595d-4fe1-b984-7fc13582cdf2	71641c61-88c7-421b-82c9-174a0e663347	t
043f3b1d-595d-4fe1-b984-7fc13582cdf2	42b21bf0-65df-4390-a003-c4f51bf006a3	f
043f3b1d-595d-4fe1-b984-7fc13582cdf2	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
043f3b1d-595d-4fe1-b984-7fc13582cdf2	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
043f3b1d-595d-4fe1-b984-7fc13582cdf2	1e13f30e-663f-4409-874c-c2fdcab59306	f
295b1d84-f59f-4336-b864-6fb3cf140de1	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
295b1d84-f59f-4336-b864-6fb3cf140de1	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
295b1d84-f59f-4336-b864-6fb3cf140de1	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
295b1d84-f59f-4336-b864-6fb3cf140de1	71641c61-88c7-421b-82c9-174a0e663347	t
295b1d84-f59f-4336-b864-6fb3cf140de1	42b21bf0-65df-4390-a003-c4f51bf006a3	f
295b1d84-f59f-4336-b864-6fb3cf140de1	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
295b1d84-f59f-4336-b864-6fb3cf140de1	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
295b1d84-f59f-4336-b864-6fb3cf140de1	1e13f30e-663f-4409-874c-c2fdcab59306	f
9f6e8285-b738-4e25-b398-bff3211164ee	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
9f6e8285-b738-4e25-b398-bff3211164ee	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
9f6e8285-b738-4e25-b398-bff3211164ee	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
9f6e8285-b738-4e25-b398-bff3211164ee	71641c61-88c7-421b-82c9-174a0e663347	t
9f6e8285-b738-4e25-b398-bff3211164ee	42b21bf0-65df-4390-a003-c4f51bf006a3	f
9f6e8285-b738-4e25-b398-bff3211164ee	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
9f6e8285-b738-4e25-b398-bff3211164ee	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
9f6e8285-b738-4e25-b398-bff3211164ee	1e13f30e-663f-4409-874c-c2fdcab59306	f
a81afdbf-f130-4f26-bafd-73e08372e558	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
a81afdbf-f130-4f26-bafd-73e08372e558	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
a81afdbf-f130-4f26-bafd-73e08372e558	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
a81afdbf-f130-4f26-bafd-73e08372e558	71641c61-88c7-421b-82c9-174a0e663347	t
a81afdbf-f130-4f26-bafd-73e08372e558	42b21bf0-65df-4390-a003-c4f51bf006a3	f
a81afdbf-f130-4f26-bafd-73e08372e558	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
a81afdbf-f130-4f26-bafd-73e08372e558	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
a81afdbf-f130-4f26-bafd-73e08372e558	1e13f30e-663f-4409-874c-c2fdcab59306	f
c335a38b-9f6c-4256-bc10-43561bb80698	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
c335a38b-9f6c-4256-bc10-43561bb80698	338168d6-6070-48f0-8c7b-b7d02089305f	t
c335a38b-9f6c-4256-bc10-43561bb80698	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
c335a38b-9f6c-4256-bc10-43561bb80698	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
c335a38b-9f6c-4256-bc10-43561bb80698	a238a12d-c366-4492-8d87-1915dedd0b64	t
c335a38b-9f6c-4256-bc10-43561bb80698	1e13f30e-663f-4409-874c-c2fdcab59306	t
c335a38b-9f6c-4256-bc10-43561bb80698	fbec02ac-b60d-4ee8-86dd-ddac69aefe31	t
c335a38b-9f6c-4256-bc10-43561bb80698	71641c61-88c7-421b-82c9-174a0e663347	t
c335a38b-9f6c-4256-bc10-43561bb80698	42b21bf0-65df-4390-a003-c4f51bf006a3	f
c335a38b-9f6c-4256-bc10-43561bb80698	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
c335a38b-9f6c-4256-bc10-43561bb80698	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
d831b9b7-10f6-45d1-ab10-621ff861dd5b	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
d831b9b7-10f6-45d1-ab10-621ff861dd5b	338168d6-6070-48f0-8c7b-b7d02089305f	t
d831b9b7-10f6-45d1-ab10-621ff861dd5b	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
d831b9b7-10f6-45d1-ab10-621ff861dd5b	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
d831b9b7-10f6-45d1-ab10-621ff861dd5b	a238a12d-c366-4492-8d87-1915dedd0b64	t
d831b9b7-10f6-45d1-ab10-621ff861dd5b	fbec02ac-b60d-4ee8-86dd-ddac69aefe31	t
d831b9b7-10f6-45d1-ab10-621ff861dd5b	71641c61-88c7-421b-82c9-174a0e663347	t
d831b9b7-10f6-45d1-ab10-621ff861dd5b	5d8dec81-b910-47d0-93ff-c7cd4f714eda	f
d831b9b7-10f6-45d1-ab10-621ff861dd5b	42b21bf0-65df-4390-a003-c4f51bf006a3	f
d831b9b7-10f6-45d1-ab10-621ff861dd5b	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
d831b9b7-10f6-45d1-ab10-621ff861dd5b	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
d831b9b7-10f6-45d1-ab10-621ff861dd5b	1e13f30e-663f-4409-874c-c2fdcab59306	f
4d2874c8-1177-4cd4-991f-9a62ce88db03	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	338168d6-6070-48f0-8c7b-b7d02089305f	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	5d8dec81-b910-47d0-93ff-c7cd4f714eda	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	a238a12d-c366-4492-8d87-1915dedd0b64	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	0636469e-a1fe-448c-83ee-9d5e5a67c392	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	fbec02ac-b60d-4ee8-86dd-ddac69aefe31	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	71641c61-88c7-421b-82c9-174a0e663347	t
4d2874c8-1177-4cd4-991f-9a62ce88db03	42b21bf0-65df-4390-a003-c4f51bf006a3	f
4d2874c8-1177-4cd4-991f-9a62ce88db03	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
4d2874c8-1177-4cd4-991f-9a62ce88db03	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
4d2874c8-1177-4cd4-991f-9a62ce88db03	1e13f30e-663f-4409-874c-c2fdcab59306	f
603d98fb-fd82-446a-aec4-03abc7a0ebd4	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
603d98fb-fd82-446a-aec4-03abc7a0ebd4	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
603d98fb-fd82-446a-aec4-03abc7a0ebd4	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
603d98fb-fd82-446a-aec4-03abc7a0ebd4	71641c61-88c7-421b-82c9-174a0e663347	t
603d98fb-fd82-446a-aec4-03abc7a0ebd4	42b21bf0-65df-4390-a003-c4f51bf006a3	f
603d98fb-fd82-446a-aec4-03abc7a0ebd4	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
603d98fb-fd82-446a-aec4-03abc7a0ebd4	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
603d98fb-fd82-446a-aec4-03abc7a0ebd4	1e13f30e-663f-4409-874c-c2fdcab59306	f
0eb5ebad-abba-4f01-b2af-56c4874059c4	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
0eb5ebad-abba-4f01-b2af-56c4874059c4	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
0eb5ebad-abba-4f01-b2af-56c4874059c4	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
0eb5ebad-abba-4f01-b2af-56c4874059c4	71641c61-88c7-421b-82c9-174a0e663347	t
0eb5ebad-abba-4f01-b2af-56c4874059c4	42b21bf0-65df-4390-a003-c4f51bf006a3	f
0eb5ebad-abba-4f01-b2af-56c4874059c4	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
0eb5ebad-abba-4f01-b2af-56c4874059c4	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
0eb5ebad-abba-4f01-b2af-56c4874059c4	1e13f30e-663f-4409-874c-c2fdcab59306	f
ee1eff39-a727-46a3-9d18-0600e356d847	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
ee1eff39-a727-46a3-9d18-0600e356d847	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
ee1eff39-a727-46a3-9d18-0600e356d847	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
ee1eff39-a727-46a3-9d18-0600e356d847	71641c61-88c7-421b-82c9-174a0e663347	t
ee1eff39-a727-46a3-9d18-0600e356d847	42b21bf0-65df-4390-a003-c4f51bf006a3	f
ee1eff39-a727-46a3-9d18-0600e356d847	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
ee1eff39-a727-46a3-9d18-0600e356d847	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
ee1eff39-a727-46a3-9d18-0600e356d847	1e13f30e-663f-4409-874c-c2fdcab59306	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
012c4282-5f36-4291-a5b9-26a02853d775	696cdfe5-9ca8-4d43-bf9a-37d3c55bb51c
62e93726-e7be-4ff2-a8a0-427cb842cb09	0ad83d6d-c9f0-4241-9da8-fe8a02a2e6bf
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
7bfd5a84-638a-427f-a68d-24a408c2ef5c	Trusted Hosts	27484249-b2b6-4f42-81db-28866ec26a77	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	anonymous
a7deb910-7ba8-426f-9140-bccc1c0629b1	Consent Required	27484249-b2b6-4f42-81db-28866ec26a77	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	anonymous
e0625f35-2694-4d13-a4ef-0f7652531468	Full Scope Disabled	27484249-b2b6-4f42-81db-28866ec26a77	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	anonymous
d006891a-c12f-4de1-aef6-13f0dcd53fc4	Max Clients Limit	27484249-b2b6-4f42-81db-28866ec26a77	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	anonymous
a9c8312f-1ef2-44d8-9480-7ea4a9779461	Allowed Protocol Mapper Types	27484249-b2b6-4f42-81db-28866ec26a77	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	anonymous
d697c2c3-1725-4e34-9a58-31d0af3f3362	Allowed Client Scopes	27484249-b2b6-4f42-81db-28866ec26a77	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	anonymous
7050eeb7-3b7e-4de0-a9a3-7aca503f9460	Allowed Protocol Mapper Types	27484249-b2b6-4f42-81db-28866ec26a77	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	authenticated
dd3116d1-d77d-4c18-8995-07b663cd0a4a	Allowed Client Scopes	27484249-b2b6-4f42-81db-28866ec26a77	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	27484249-b2b6-4f42-81db-28866ec26a77	authenticated
cf9230e5-13a3-4194-98d4-f042ceefbcca	rsa-generated	27484249-b2b6-4f42-81db-28866ec26a77	rsa-generated	org.keycloak.keys.KeyProvider	27484249-b2b6-4f42-81db-28866ec26a77	\N
12fce6bc-5bb9-4f1b-91b7-6279f93581fe	rsa-enc-generated	27484249-b2b6-4f42-81db-28866ec26a77	rsa-enc-generated	org.keycloak.keys.KeyProvider	27484249-b2b6-4f42-81db-28866ec26a77	\N
e62f6e7e-d293-4f1b-950f-69b88ef474ec	hmac-generated	27484249-b2b6-4f42-81db-28866ec26a77	hmac-generated	org.keycloak.keys.KeyProvider	27484249-b2b6-4f42-81db-28866ec26a77	\N
a9a9ffd6-f4db-4ad5-9493-a8b8d310a985	aes-generated	27484249-b2b6-4f42-81db-28866ec26a77	aes-generated	org.keycloak.keys.KeyProvider	27484249-b2b6-4f42-81db-28866ec26a77	\N
f2d16d2a-fe23-479a-83f4-fc8cc96bfc68	Consent Required	esdl-mapeditor	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	anonymous
8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	Allowed Protocol Mapper Types	esdl-mapeditor	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	authenticated
30c2f7e1-f11d-4c99-93ce-6a45a8f86ac1	Max Clients Limit	esdl-mapeditor	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	anonymous
7b680895-bbb1-4666-8e44-8f816a406f69	Allowed Protocol Mapper Types	esdl-mapeditor	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	anonymous
cd999a52-d53e-4cb8-a4be-f43fc684d991	Trusted Hosts	esdl-mapeditor	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	anonymous
dbbcda9d-6155-4921-90df-b4ba289e6f36	Allowed Client Scopes	esdl-mapeditor	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	anonymous
06e7544e-4c67-4042-ad49-44568bfeb545	Full Scope Disabled	esdl-mapeditor	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	anonymous
400480d4-ca27-40b8-9073-2f0f816287c4	Allowed Client Scopes	esdl-mapeditor	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	esdl-mapeditor	authenticated
f61be265-2e96-478d-9e0d-75ad5bbb19dc	hmac-generated	esdl-mapeditor	hmac-generated	org.keycloak.keys.KeyProvider	esdl-mapeditor	\N
15d3f82b-cc2a-4844-9183-5635d18b16af	rsa-generated	esdl-mapeditor	rsa-generated	org.keycloak.keys.KeyProvider	esdl-mapeditor	\N
80428a8a-8a65-4f6f-9b11-effad2d7907e	aes-generated	esdl-mapeditor	aes-generated	org.keycloak.keys.KeyProvider	esdl-mapeditor	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
66318cd6-c36b-4eda-bc4f-ce9a03b7531e	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
02ddd163-3004-411c-b0ff-123ceb1923ce	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	oidc-full-name-mapper
1eda8b86-6992-47e9-a4ff-08d52c0a2e58	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
756f9f2e-bbef-4922-b696-3b3b30fefa4b	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	saml-user-property-mapper
73b754f7-83e4-409f-9ae0-dca7b319d877	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
5b763d93-4a2b-4218-a5a4-50c63341785e	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	oidc-address-mapper
6852186c-af3f-4f8f-996a-a7142ac78110	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	saml-user-attribute-mapper
cd27b6bf-17c1-432c-b8c6-667192f7b395	a9c8312f-1ef2-44d8-9480-7ea4a9779461	allowed-protocol-mapper-types	saml-role-list-mapper
d0a19f23-e23e-45d7-a46c-787b5495e8cf	d697c2c3-1725-4e34-9a58-31d0af3f3362	allow-default-scopes	true
5fef27e4-362c-4221-9b67-1318d370c14d	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
4583b2e3-8d19-49d3-a314-1d0377bf7b64	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	oidc-full-name-mapper
e51ad0a5-e3fa-456d-bd45-5f2cb2d7e9b1	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	saml-role-list-mapper
1bdf90a7-05e9-49d7-95e5-9c3ffe9d5351	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
505e556b-8f0d-461d-ac70-b1df0578e9ba	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	oidc-address-mapper
93661400-662e-499a-9eb2-0c6fea89c47a	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	saml-user-property-mapper
cd798fd7-8afb-4247-9a3e-a1099d6de072	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
86da2626-4f91-4058-b333-58f42575abcc	7050eeb7-3b7e-4de0-a9a3-7aca503f9460	allowed-protocol-mapper-types	saml-user-attribute-mapper
2f1c927e-bb7c-46ad-a412-24bd9aac35c4	dd3116d1-d77d-4c18-8995-07b663cd0a4a	allow-default-scopes	true
dafef6d2-d07f-4203-832c-b670ac3f0e7b	7bfd5a84-638a-427f-a68d-24a408c2ef5c	host-sending-registration-request-must-match	true
952afc59-7288-44b3-8a4a-63b216b848ee	7bfd5a84-638a-427f-a68d-24a408c2ef5c	client-uris-must-match	true
ac91be17-7074-428e-a8e3-785877deafe7	d006891a-c12f-4de1-aef6-13f0dcd53fc4	max-clients	200
cd273388-fa9f-4bd3-ac3c-d6fc23cac62c	12fce6bc-5bb9-4f1b-91b7-6279f93581fe	keyUse	ENC
290ba660-2248-48e8-a594-21f7b69653b7	12fce6bc-5bb9-4f1b-91b7-6279f93581fe	certificate	MIICmzCCAYMCBgGXhNwK3DANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNjE4MjEwMzIyWhcNMzUwNjE4MjEwNTAyWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCmh+7mvO57YH4jm8qvuPkNCTo0hGKQzsVhlrw8hjT8yjZG+NefrDd+bdqyfjQUtrylQb9DxzTmGqQwbF2OVMnfRMCFUq2W/FchqF784rubrdfFTDnNXfwVO++vDN5XqUr6DXjKwWTJhIxnW5s2FuU5CeEcV+vjalF5CyytBbIUUGNwDTV5tN+IZJK/a/siGIuuJYGXyFGGeoIaE5C4ag7iqdF6dkyclFUUnzalKMw6mA7Ti9LS570b39G3MSV7DlbLQAA1Bdqw/MLN1QFpL0tomU7QL3249bC0gj9nbwmCmzcVcSlMP55DHSm6Ni/z8g2YWFmOm00IEv8VtuyiiiK/AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAIvlxqqanVtSiv6LX5HH4cG4RoYGzJmDUTuohOiKuTp5ROxJInzVyWzKUFjw4/dkxYeP2+OSBlTGSyDmR7LcajIrec0ZfKaDgF1OFMFiPacSUWlVMQdNKZQ0ziD8uv2Uo0IaofPesy3+n5GM5z32MXed0tpahZ20x6g0P8lokKfNsr+mfGmOYv835LHCon9hMb8TR10uV4e/+rTV4FvXAwfMGfw7Yxssf19aBcybo0T/HMyWEgXLFTerIH3FuaTGNr2kkE1g6I40EyZTjXwupcxA583ZZSpbsf4C+GNbkopMtGGZzhDkEXmEM8T7SiMDcK+JXmh6O7iVPl+iXgz+A1A=
b5de1fe5-a072-4f4e-8bfa-e2e973f31885	12fce6bc-5bb9-4f1b-91b7-6279f93581fe	privateKey	MIIEpAIBAAKCAQEApofu5rzue2B+I5vKr7j5DQk6NIRikM7FYZa8PIY0/Mo2RvjXn6w3fm3asn40FLa8pUG/Q8c05hqkMGxdjlTJ30TAhVKtlvxXIahe/OK7m63XxUw5zV38FTvvrwzeV6lK+g14ysFkyYSMZ1ubNhblOQnhHFfr42pReQssrQWyFFBjcA01ebTfiGSSv2v7IhiLriWBl8hRhnqCGhOQuGoO4qnRenZMnJRVFJ82pSjMOpgO04vS0ue9G9/RtzElew5Wy0AANQXasPzCzdUBaS9LaJlO0C99uPWwtII/Z28Jgps3FXEpTD+eQx0pujYv8/INmFhZjptNCBL/FbbsoooivwIDAQABAoIBAEKD2+vEfdrArVFKujfawXsv+tQcJoRhWlxCyTfBgSuRFwHdBb7smhPBDA+sMeAuJwY4zwzi5eGctYTz26BshF9NxjnaTqSWcLTsW9hVNYsWci8HZbT9+6B9mpwIH0zTPTPIKr2NZlTJQQ1NfR6rIW5ZYFUiVwE0J4uZ54PKWRkcZn+klo1ut3A5imMQVp2bARQc1y0vs6e1cxVCITz24lsggO+Ldcy5S0g2TDw3BpTDn+jpB5sOvxEgtBqM0rqgHAdQfMR1Y7wl+BVsQ7V07+KVOQSeYOsp0SzUn4B5SkXzgJlZwz0TKxTiJJseOif5PwWWlY1fD550fdsbr+SBMhUCgYEA6lYEa1jdKeVPIQGCopJF4hU4SNYua8uApvHKV5NmkdQd9qnM4XUbTJwUx8KXPJ7Gg7/zmOY0vt7hL7Vd7pcsvtQAgx9YuuZWCSu58aV4/aLSBJiQi5Y4hXB0d08kKeiIR0n7FmRaIP+m6HDlE/ozn6flz48IMWhnsG8PEtH9+YMCgYEAte0wOXxBnujRjpYTifrA8JPn0MhNLnugZdFWQnp7kPLhd1g5mmiAngNfniuJqnJG51QmxWSZvZSg5Duz0ZKCoW7xP+wsnv8jJBoIE+ixYFgaLWSZWfjQ0DC54fYfv0XBSjNKGSgdvbEtzT83Sbutc6q7OIxKJ+Wr8JuZZrb3uRUCgYEAgnXdA/53MontYcy7c9LHgTSbH0HOmkizmT3njpYLdoiHHfoujB5sUlxa3VOiaydiEZtd/PO8zb6705m/b8NOL/dLSbS762Gs6HIllTiwgVSSY+ikIHJDiVawIHQ5B/PjWvz/AtpfqxtpSuL/Rf33m50XvlQ9FXSwtXM/CxVJtg0CgYBdLsAksaBq5JVxky0u32Ez2I5EQlRGGsxtWmv0YQgplj4mAup+TEiUpuWy/lnlE+N9WX0CXiThFd/TB0FzdreyOEEZnL6+MbCuLSc2C1nPH1FJLt3dV7Sc7lhHhOl97xyyBNNPT1zsbHQpTNfkzFxrgmei7ziMdvc6pnhMRCtegQKBgQCmtvsqwrZEEgVIKAfugupZuNW1cEnZ9uOIkjtRPILMZwPbLnRGQce8jFLL1L9sQGgRnoVwhc2cGbzNMy97DYzDWzQzwPBIvN5r/r7+pdmfRYaIcRviaocR1FxuVapV8LLfGloz/rpMBpbO5wPcf0ezAnLeomKhNljPjNkqSR+yew==
a1739d62-2f7d-415e-92a5-137818e82ff8	12fce6bc-5bb9-4f1b-91b7-6279f93581fe	priority	100
a6d0ae92-662a-4001-b622-02b58f9c62ef	12fce6bc-5bb9-4f1b-91b7-6279f93581fe	algorithm	RSA-OAEP
f72ba2b6-21cd-4365-8a6d-987ad243b6d4	e62f6e7e-d293-4f1b-950f-69b88ef474ec	priority	100
2c5e2d2d-42b2-4762-91bd-839aa0158399	e62f6e7e-d293-4f1b-950f-69b88ef474ec	algorithm	HS256
24bd31a7-93b2-4306-b4a3-5a4f8a6276c6	e62f6e7e-d293-4f1b-950f-69b88ef474ec	secret	-fk5t4smPEIxOHJLoUe_s17AFhXuMVFqM_BIbhFxYb8kPn8gbu-CpuxNnensdWRHOO8aSLl6Njr-3SmLPf-GPA
4b9a94a0-4fe6-407f-acf1-2b17aa70f33c	e62f6e7e-d293-4f1b-950f-69b88ef474ec	kid	c08cea75-b162-4ad2-8e93-4e1a88359964
bbb9a81f-f509-4cf7-9e1a-ff0ab9c064b5	80428a8a-8a65-4f6f-9b11-effad2d7907e	kid	934082a6-e5a1-4625-a561-a76cc17f9d69
10b2244d-af48-4109-a39a-9da7ebe6282d	80428a8a-8a65-4f6f-9b11-effad2d7907e	secret	rfCbC9dEUd4dIj7P-i5d_g
eadcd943-6917-4897-88a3-3655eb10436a	80428a8a-8a65-4f6f-9b11-effad2d7907e	priority	100
52cb4d38-196d-4c17-931d-fb9a43dfab4c	30c2f7e1-f11d-4c99-93ce-6a45a8f86ac1	max-clients	200
81ea66fa-09af-4868-9256-f554163d3e06	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	oidc-full-name-mapper
39b03702-9567-44af-aec7-5ae629584967	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	oidc-address-mapper
7f3445e3-7a0c-4831-99fc-746876218685	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	saml-role-list-mapper
831aeaec-8052-44e5-ad95-2f08dc07b4b2	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
ce4db6aa-c08f-4573-8941-82356faf099a	cf9230e5-13a3-4194-98d4-f042ceefbcca	privateKey	MIIEogIBAAKCAQEAzQ1ZeRQK5lB+odQ6R/VjevaPCSybNEzMAZ/cFlsw0JbNzbMgqTyqEk7sR7I+7vGlRWO0O5PZY4mCV2YogcKMShaeZ6BdUZqOTgOHybmiRAeKHwRBP0ji6tGkgzyCBCKF4Gpfak8cqXORVezukKCKO+O3XlS5iUN3F/P9Um4VWYpzRtkNWJ1NWm7H0ElhsEx/BLyxtZAKkOw7Qc24SW8Gyu1LMEqznGIRQjvlulBZx1/e7jDBcFVs2NiMasRKFCQJ80ZuktyqhME+cybxZXYqjEjOtaPYvOGxdt0+Lvfqf/WXUnwrDrs93weMeHfVrEaG0Om4DF5c6xmVe5NSE0l2owIDAQABAoIBADDmzZ9ECeNqcADNGccefQaOtYcFFdCPvhlnE/ha8BXW2ScE4LWrq42pN81Tc5HNnFIjmJCazn3gBe8tBF0J1iY3Jbjl9EtpViXBzsjrlgiuWaDTBXJ/weopbBgGPqWYzB+8jpvOWTIKRy9cTXq9ZqoowQrknsjfB5B1VkUpzrqnDkb8QcDhrUD2Y/BVQ/vlQ5gQghygQMnMe0e4sSBXFaAsVzSrK1h48i/9k2Lv5IueJlnLubfUQnAzTIg/cisprb28dQHr1tV/ZpDLtzhbGYjyQAzWW06tPlFmLV7Lm6Mg0SaHp2li3o9zjwNl4RfcUHZxt95GIbdFd39PgQepEMECgYEA7LFSXudKPHd6EVkKtsf5l9sIx41MytoyPfCUvKTJW2zZY47n8Yb4DOzO9J/PTx2VvZRt3/XN0NA7TT9QTJjAZAYBIefXDfILAggfCKqIgenW8a+ehmBijLjUqk08hrTpOlQFpjcbe0CfMphZiblFAN+y+RLvwde9LJaS91Vcl+MCgYEA3cdNW7NRWAtHgvtn58t76rhS32sgCOqBVRDinhWLzIPTCWE407J+r1nPlorSB4B6Up7SwIfjLGrtUCVmu4VVf36G8ZOgao2t+LxVQo+qWZAUNOnPGpsOdluikj6JkK09HqxfiixO/JaG+QRsvtJIGrxQYfTe1B45w16AvOZ2YkECgYAzjUOFjBatKNCbaqtcuB1yp7A31ly9ady7hOTAWZvJn+GRP5ThFCZ+mi1RNmVus+DjU6rCtsTHEDN6VanlpPdyUaR5gAdk8CzZmm838fydXxMDvN5oIiIUyET5eq0OIeUSYS6Bz0rbA24pFOmbh5Cx6gcPHMK/k3+OcJU97YenRQKBgF/6QoYu4kMiDn6m4l6z9xqrTmIV8DUrl3EC76/OT0PgwNHMW1VyZ9TnHyldRmustENRLI/ZvvyYAb+vj/gTSd71GN0vMDssuV9t0dAOcIB2E+iaTuCKvgWGvqJfohUUg+DkZCxd5Ij3c84Mlis2wbGgUYEzAcP2mLTuDvSxIAaBAoGABp1ZbAWW2WFenfNaS9trcI1q4zYkzX6obWx59cnkK5SikQVRPCbrA7vanxaz8+LX05BGwo4mNreTuMPaqrqGp94V7tjlz5Ntak5JcpqdURH4AtmTmVy0ziCKJ5Xejcrea8w0Zz4Fed8NH5d7NnS9s+vXUnVmKbCynlp7iSy8k7U=
73de64ea-5dda-4675-9dd0-f318d63e8c51	cf9230e5-13a3-4194-98d4-f042ceefbcca	certificate	MIICmzCCAYMCBgGXhNwFYTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNjE4MjEwMzIxWhcNMzUwNjE4MjEwNTAxWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDNDVl5FArmUH6h1DpH9WN69o8JLJs0TMwBn9wWWzDQls3NsyCpPKoSTuxHsj7u8aVFY7Q7k9ljiYJXZiiBwoxKFp5noF1Rmo5OA4fJuaJEB4ofBEE/SOLq0aSDPIIEIoXgal9qTxypc5FV7O6QoIo747deVLmJQ3cX8/1SbhVZinNG2Q1YnU1absfQSWGwTH8EvLG1kAqQ7DtBzbhJbwbK7UswSrOcYhFCO+W6UFnHX97uMMFwVWzY2IxqxEoUJAnzRm6S3KqEwT5zJvFldiqMSM61o9i84bF23T4u9+p/9ZdSfCsOuz3fB4x4d9WsRobQ6bgMXlzrGZV7k1ITSXajAgMBAAEwDQYJKoZIhvcNAQELBQADggEBACYfh5eGoOXFsXxGb0Z26GL28qNDmeff6pg3VaYqjnNkkPDLVaL89Qy9/eiKdLL6mC+QzUfxdEJsC7nYNkE+ulwgT3HOeJ7SeAYCAIcjemyXb0ub5WutAkvnEFEfwlnOTh+ld8MJ1Ti/DVAQn6Ymp5UqoXqJdVjgVJ5fA9CpmMZxeoOv+636crIy0q5nx+z8DLHwbezvUT9PZBIDcrzYCq/HJIO4MpzPvCM1Gou0+tSM+C6ctti3O0itjZYHNjZUH6NhEPzWBw8WCk+eiYoOTp+iHQ61ZBX+cZCKIKI3e9yin6LWfGh6h9myXlv0eHEAilvS/YOerPC8HJVO/V+dSlM=
bee1bd71-d872-4ab2-85aa-0ee94a8f8d3a	cf9230e5-13a3-4194-98d4-f042ceefbcca	keyUse	SIG
eead613f-9a50-453b-9f6a-91d0f77d04d7	cf9230e5-13a3-4194-98d4-f042ceefbcca	priority	100
fdcee4e0-8799-4717-a5f9-a7a31db1af7a	a9a9ffd6-f4db-4ad5-9493-a8b8d310a985	secret	LlNNPnea3D_1fkAYb1qc1A
27dc6ac9-6786-442c-bb86-4f9edb2de6fb	a9a9ffd6-f4db-4ad5-9493-a8b8d310a985	priority	100
57c7b6d7-0ac8-4d8a-8c69-ae80e2fd5b70	a9a9ffd6-f4db-4ad5-9493-a8b8d310a985	kid	706c38e3-df7f-4711-940c-7fb60999d170
23ee6d5d-a3b3-456d-b25e-9a19ac0d5a82	f61be265-2e96-478d-9e0d-75ad5bbb19dc	secret	0kOKK3DIIp2rVCgbIdK3_DLs4KtCe5v3at8FuRd-DCy3cXVln0YcrWgr4qsdavJw4yac_hzJDVYT20Pyj_vnnw
b86c9e76-1708-4a60-87f1-7646d544f513	f61be265-2e96-478d-9e0d-75ad5bbb19dc	algorithm	HS256
f180e8e4-4164-4b24-9368-6cc6ec71a7bc	f61be265-2e96-478d-9e0d-75ad5bbb19dc	kid	5f293547-fdde-46f1-88f0-cf301c6be8e2
cea75002-0574-4d64-9460-eb5291fc63a5	f61be265-2e96-478d-9e0d-75ad5bbb19dc	priority	100
539cff52-ca55-4345-87f1-0413caf6b48f	15d3f82b-cc2a-4844-9183-5635d18b16af	privateKey	MIIEogIBAAKCAQEA5ytmlJsyjPJFvdFi14Sri2dKMclSo6PGUMR2WdRh+82L/oTpPMB7pfQApm2eOEDSV9JNRD3IXLYUhqE5ASR+arTxRE75nM4ZPy65+qXVC3PXDnrbrth+xW76UbMgNLMex2pLD0GMvwlLfA2YOKfCoOhkgSiCcUnHsRGmI3FD3FMxIqDRoOFR7NSQ99wrjAJriW3UQbsn+QVuRlUHdKWP1O2GRummKiPvdOOSxWYeF66401GL+cCRxDr7CtGnmXayZLRJZ9haBUqI1KIO/xFiPayYAZvMEf9aeiNY5oylRXU/BWokHPwzbt3feVkMHtB47aVfv5t28BI7UWGIwdjOPQIDAQABAoIBAEaZY5+48ixHhXMeMnCdjQJrDia8VGezicp65aYzjaUoNjwJ/W1XX6vkJBqv2aVWbqbxjDVuJPXjictAC7fEnHMcRZ7V+7ee3ekE7TmWUcVIoIJElTkF11mWtg4jhY9ysNC4Lqo/G6vwO8RsJnQPEAqyTpd/dq8AmGMEf9fNLKtpjDP/AwrPCv3/80o1onlGBHfnBJBoakEEhq3ZpLP0tZvfEH/i0uc8SVIXolWR7prosY2PRZSJFHY5c8WsS72R0qWuH+cGXn7PlKJzOrnc3vyBtb+GGta+eoq70+wm6Sg221af55m9qtnJ/ZfuXTphwvQbbekX+gyDTehc24bg2aUCgYEA+N9/61dS+OMhwy8MQqK4nQaVJLQlRRqO6wZ9ur/P3oOgY76wN9CcKOmFmGtaN+lj2dHKT07zjk9pprC2cy67PaXgf50eR7EQJVYioDzZlRtJ01BR28BfuHRmbbfRzx6zz4sZlwhfudjjgquAxI0qd8mu7wA/REm1eDi7P+9GbwcCgYEA7codn+35w6HxgvIZvXakQD6T6yaiwfduwLcbgPkeEPt+oQemqfCBg5GpGnP7ZbQGb8Bz8n+CeJZEBWhxhZy1v62QK7NXrl6jdMYJSRBsdhqCxER4TKEPi5kd+ghPQKFDDyWm3uR6PYDjfQYsoVkaKaL3bNBsisuKH9F2DaHFg5sCgYB5mRIyVb9XlfqIGHPAFytmpbG3dkGDix9rXAeQeGnDScLTGXeWPdoe70J0H3e8O8+qvKNBrsy3qrtvU4ZBrwKTc3nGQGlsE+pUo8pVSoXxIZ0nn2XvngXm5RCq6RadQV4PuOIu9kt3Ta6TyOIopuSqFKPhaNiAsBb3f5iV+34JfwKBgGK2UtH/cn3aDm4znqfeRpU85R7rLQmkc9+go9RIlkiqfojOqktFwh4iK7cFislPkJR3qipy8HCqwJYWI3o58eEeZgkeLDoAo45oX5ZrMPteSga7/cyh19g1uhH/vRaxWytAkCNbabt6c/WEyKY6XPgH5PrREx4THMXUqFNEYsAdAoGAZ60GhiKU4ogQDi9Glc8qK+KyL8zMMtIQ/g7fn4LsfvhtKHeiEZ4anlLo4CHDAcVHOSY/gZnqVtdteL0xCgoCjONdKYLg0fpjUmgvfgS/V7lUWyhf8t4pyECgecYh9iJVv0tZ2MA0sxwiKLpzXbEzKVAAbBtvQgDqnAqx7d3JgnY=
c0496229-c688-40b6-9418-0ca0aaa08cf9	15d3f82b-cc2a-4844-9183-5635d18b16af	certificate	MIICqzCCAZMCBgF0RBLNxTANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5lc2RsLW1hcGVkaXRvcjAeFw0yMDA4MzExMDMwMTdaFw0zMDA4MzExMDMxNTdaMBkxFzAVBgNVBAMMDmVzZGwtbWFwZWRpdG9yMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5ytmlJsyjPJFvdFi14Sri2dKMclSo6PGUMR2WdRh+82L/oTpPMB7pfQApm2eOEDSV9JNRD3IXLYUhqE5ASR+arTxRE75nM4ZPy65+qXVC3PXDnrbrth+xW76UbMgNLMex2pLD0GMvwlLfA2YOKfCoOhkgSiCcUnHsRGmI3FD3FMxIqDRoOFR7NSQ99wrjAJriW3UQbsn+QVuRlUHdKWP1O2GRummKiPvdOOSxWYeF66401GL+cCRxDr7CtGnmXayZLRJZ9haBUqI1KIO/xFiPayYAZvMEf9aeiNY5oylRXU/BWokHPwzbt3feVkMHtB47aVfv5t28BI7UWGIwdjOPQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQDkdt/GA7+JYbGvIBh65EhAGOWjUB0zEX8OW6MPk3TO9eMt83Y4KeyhfRoGxqALYD90a4uVx3INwk04bzswZuxVAcaVVtTqeHFr8uzhuRspq1eWeqIxmPn7smk/cWAtCZFXRqCAs/Rh3LgdV2YGbczqSn9I6pjWlpCt0yI7FaxJ/k11dFyUPTifZY8nHC11G0FyNfm3C9bts+cqeAkcC3vemf4CruQzaHHOiHRIrrIU+jhp7uZEMLp5XGqQXOHlJsJbU7YBHZWRBPgD0IE0EBRnRrim6rID6Mkan44MUaOOS2+LS7/AOvwBEqNrP0TtMt2O7egwpgQ/jNgsBzY5hnEq
10d89b67-6a6f-45e5-b314-228d36b3e35a	15d3f82b-cc2a-4844-9183-5635d18b16af	priority	100
a7e2a3c0-3c66-4f99-9cf7-5a37d3347811	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
a60331a6-2c34-438a-8ff6-30a866c1df2e	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	saml-role-list-mapper
7cd81b2b-344a-4fb7-8506-1fac5b969a88	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
28fc175a-8026-431b-a62c-5a47c7bd3823	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	saml-user-attribute-mapper
23b1e1d2-480d-45c6-863d-8377ea264475	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	saml-user-property-mapper
3228721f-867c-48b4-8579-3581094354e0	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	oidc-full-name-mapper
b2079167-71f5-46b2-b122-97eac292bef5	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
1b5620f0-1d75-47b6-89f0-8788dee1ddd3	8d43de4d-2ae7-48df-9fa9-207a3cdaf51a	allowed-protocol-mapper-types	oidc-address-mapper
83bf6231-ef97-40e2-bf39-2f60a37cdbc0	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	saml-user-attribute-mapper
9f947006-d81f-46b0-a3f0-ddec8a574eef	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
defdaf8f-b350-4d48-a748-dcd9da30a3a7	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
f0025168-d619-4c5c-86e4-57949b58b50d	7b680895-bbb1-4666-8e44-8f816a406f69	allowed-protocol-mapper-types	saml-user-property-mapper
6b7b3a1e-d9cf-43b9-ac35-224de8774c19	cd999a52-d53e-4cb8-a4be-f43fc684d991	client-uris-must-match	true
7eaab1e8-b0af-43b2-8991-255769d92047	cd999a52-d53e-4cb8-a4be-f43fc684d991	host-sending-registration-request-must-match	true
bdcc2e77-15b2-4769-b73e-80bb885431a8	dbbcda9d-6155-4921-90df-b4ba289e6f36	allow-default-scopes	true
69afbfad-bcb5-41a1-845e-ea40acb2be4a	400480d4-ca27-40b8-9073-2f0f816287c4	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.composite_role (composite, child_role) FROM stdin;
0911a89f-8275-4bb6-960b-4252db55883e	e9303386-0a07-4903-baef-fb4955045a31
0911a89f-8275-4bb6-960b-4252db55883e	3d7eb88c-305c-4882-8fd2-7147bafd17c1
0911a89f-8275-4bb6-960b-4252db55883e	f28f59c9-a17f-4214-9fc7-1fd9b0807d37
0911a89f-8275-4bb6-960b-4252db55883e	88c1fdaa-b6b0-4f5b-9759-5f531e740e25
0911a89f-8275-4bb6-960b-4252db55883e	8ea6d134-ad6c-4e53-9580-b83d3b220618
0911a89f-8275-4bb6-960b-4252db55883e	174a5f3e-0449-4bdb-af5f-65e7e96719bd
0911a89f-8275-4bb6-960b-4252db55883e	d9898f30-4589-4833-a98b-cfe79e6996da
0911a89f-8275-4bb6-960b-4252db55883e	016356b5-0b73-4c39-9d74-f810a8c30421
0911a89f-8275-4bb6-960b-4252db55883e	be667ea4-0abb-4262-8b7a-fd208fe81be1
0911a89f-8275-4bb6-960b-4252db55883e	b7256db8-a156-4e00-8c47-a76681ae806f
0911a89f-8275-4bb6-960b-4252db55883e	43832dfd-9fb6-4543-b99e-c28c002ee380
0911a89f-8275-4bb6-960b-4252db55883e	a52dd83b-564e-40cd-add4-9659448fbb55
0911a89f-8275-4bb6-960b-4252db55883e	b1b4a56b-3c7e-4eb8-936c-a6a844bda9bf
0911a89f-8275-4bb6-960b-4252db55883e	876a451c-782f-431c-b775-139d182d5922
0911a89f-8275-4bb6-960b-4252db55883e	51de6a5c-3573-47dd-af3f-fe9fef204a9b
0911a89f-8275-4bb6-960b-4252db55883e	310fe2bd-2098-46f8-b427-f37330edfa93
0911a89f-8275-4bb6-960b-4252db55883e	2b0a0ef7-9bec-407d-9dfc-90577a012114
0911a89f-8275-4bb6-960b-4252db55883e	8088fef0-ac21-4ee9-ab29-fd81616fc59d
88c1fdaa-b6b0-4f5b-9759-5f531e740e25	51de6a5c-3573-47dd-af3f-fe9fef204a9b
88c1fdaa-b6b0-4f5b-9759-5f531e740e25	8088fef0-ac21-4ee9-ab29-fd81616fc59d
8ea6d134-ad6c-4e53-9580-b83d3b220618	310fe2bd-2098-46f8-b427-f37330edfa93
de8d7a77-af60-4af7-8dc0-a01d2aaf6c48	f6037888-386e-4a83-8819-5380633b80dd
de8d7a77-af60-4af7-8dc0-a01d2aaf6c48	1e7dd160-cdfe-4dff-a4af-d9284466ee09
1e7dd160-cdfe-4dff-a4af-d9284466ee09	5cce4307-41d3-4ce6-ae28-f1885e5ebe7d
c5a4b87c-6487-4560-bc52-aea187657ba2	3b33b1bd-5e1f-4fb5-90a2-c34e908ad7d7
0911a89f-8275-4bb6-960b-4252db55883e	0548a9d8-c2bf-4adb-a330-bac73d29c243
de8d7a77-af60-4af7-8dc0-a01d2aaf6c48	696cdfe5-9ca8-4d43-bf9a-37d3c55bb51c
de8d7a77-af60-4af7-8dc0-a01d2aaf6c48	a6cbcb2a-526a-48f3-9762-364860ed67bd
0911a89f-8275-4bb6-960b-4252db55883e	7ee203c8-9329-4374-976c-5fd01282ae96
0911a89f-8275-4bb6-960b-4252db55883e	e9624eb4-f121-491d-a9c3-e519d09394bd
0911a89f-8275-4bb6-960b-4252db55883e	e26270fb-4930-4ced-b234-1135a1b8f608
0911a89f-8275-4bb6-960b-4252db55883e	ab058e32-17fb-4a4c-b740-341ef4694ad2
0911a89f-8275-4bb6-960b-4252db55883e	3aa484e8-a49a-4425-865e-74c26c69d092
0911a89f-8275-4bb6-960b-4252db55883e	ca23f832-91c4-4c05-84ba-0bcecfb1b0ab
0911a89f-8275-4bb6-960b-4252db55883e	8b7d1b7a-7bf3-4b39-a025-472e793f9386
0911a89f-8275-4bb6-960b-4252db55883e	db89105d-f183-4a0c-938c-0e2628a34e31
0911a89f-8275-4bb6-960b-4252db55883e	f038ba1b-9e36-4d8f-a1d5-658364e83110
0911a89f-8275-4bb6-960b-4252db55883e	e5981d58-57b4-425a-844f-97383e91628c
0911a89f-8275-4bb6-960b-4252db55883e	1aca210a-d49f-416d-b8c7-09cc055e11c8
0911a89f-8275-4bb6-960b-4252db55883e	8be0e294-6fdd-4bd0-a89a-df5b1de4a3ce
0911a89f-8275-4bb6-960b-4252db55883e	ca08d7a2-dfac-4137-96cc-1f4d6ac72d23
0911a89f-8275-4bb6-960b-4252db55883e	c7ee3e24-315a-485e-a7ba-6e0258b62073
0911a89f-8275-4bb6-960b-4252db55883e	7a49202f-aa76-4ace-91e2-1ac9602e97cf
0911a89f-8275-4bb6-960b-4252db55883e	a311004f-4ed6-4e77-9f87-78a7bbfc6083
0911a89f-8275-4bb6-960b-4252db55883e	4cdfa079-3de3-40a8-bf49-b6d982620bfc
ab058e32-17fb-4a4c-b740-341ef4694ad2	7a49202f-aa76-4ace-91e2-1ac9602e97cf
e26270fb-4930-4ced-b234-1135a1b8f608	c7ee3e24-315a-485e-a7ba-6e0258b62073
e26270fb-4930-4ced-b234-1135a1b8f608	4cdfa079-3de3-40a8-bf49-b6d982620bfc
3886d03b-97bc-4d0e-b0ab-f30d5281994d	6b3509fb-90ad-401b-8470-72ba6f93ee61
3886d03b-97bc-4d0e-b0ab-f30d5281994d	9ca6f75d-bb84-428c-ba3a-61b94a2d1feb
a1f7eb1d-8611-4529-9710-c85994fafaaf	5d3b8c97-ef8a-416b-9c2c-f9d248aee49d
b5df27f4-12b4-4138-bf1b-0c21f7793342	639ab8c1-b414-4ef7-8cd8-d280e96570ff
d1510da4-d458-4d2a-9cc6-ae62d900ed7e	0ad83d6d-c9f0-4241-9da8-fe8a02a2e6bf
d1510da4-d458-4d2a-9cc6-ae62d900ed7e	d4eb6018-6682-4096-9f8a-e02c142beb96
d1510da4-d458-4d2a-9cc6-ae62d900ed7e	a1f7eb1d-8611-4529-9710-c85994fafaaf
d1510da4-d458-4d2a-9cc6-ae62d900ed7e	b1427348-28b2-42be-8fc4-6016e39387ae
d3d57617-1182-4303-bd79-dce7d1185f98	b5df27f4-12b4-4138-bf1b-0c21f7793342
d3d57617-1182-4303-bd79-dce7d1185f98	2deb5e67-19e9-4a5c-9009-3a31aceb38ec
d3d57617-1182-4303-bd79-dce7d1185f98	3886d03b-97bc-4d0e-b0ab-f30d5281994d
d3d57617-1182-4303-bd79-dce7d1185f98	6b3509fb-90ad-401b-8470-72ba6f93ee61
d3d57617-1182-4303-bd79-dce7d1185f98	5e10ce66-93d4-4c9c-8659-9e4480aac309
d3d57617-1182-4303-bd79-dce7d1185f98	277d1d15-1034-4a91-9cb8-275e8aee0354
d3d57617-1182-4303-bd79-dce7d1185f98	bd874f35-c7f5-4881-8d77-0e8595885791
d3d57617-1182-4303-bd79-dce7d1185f98	c4d5e6e6-4c90-45ef-823a-12c8a90f6853
d3d57617-1182-4303-bd79-dce7d1185f98	639ab8c1-b414-4ef7-8cd8-d280e96570ff
d3d57617-1182-4303-bd79-dce7d1185f98	4d66ce10-9a8b-4c6f-8dc6-51589161434a
d3d57617-1182-4303-bd79-dce7d1185f98	d74c8164-1de4-46ab-8a92-a071389a7aba
d3d57617-1182-4303-bd79-dce7d1185f98	589ca649-6453-425a-a705-04c43ec4650c
d3d57617-1182-4303-bd79-dce7d1185f98	30d570b8-9e3e-46ef-b150-183fdf7b595d
d3d57617-1182-4303-bd79-dce7d1185f98	da180e64-4334-489d-a889-329019ade8e3
d3d57617-1182-4303-bd79-dce7d1185f98	ce237498-d919-4c64-8aef-2129fa6eebb4
d3d57617-1182-4303-bd79-dce7d1185f98	2d5d92fe-315b-4033-b04d-22a54704abfe
d3d57617-1182-4303-bd79-dce7d1185f98	5d61563a-1612-452b-b4c3-d99e631c0b66
d3d57617-1182-4303-bd79-dce7d1185f98	9ca6f75d-bb84-428c-ba3a-61b94a2d1feb
eaec7753-cbdb-4cc0-a20c-c2cdf87ee2d8	9b0cec72-43f3-4972-85e6-299a5228795f
0911a89f-8275-4bb6-960b-4252db55883e	e3d70c03-60d3-4403-9d57-e3005ef88a7c
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
074e7df6-e421-49fd-8c5d-6d3d574dce08	\N	password	66c445f6-57d8-4caa-b577-0c50df4932da	1750280703874	\N	{"value":"O8G9h8a9o/+YjDSYXQsOdOgQwr8kd5xufLUWuz7DHVGV9r9tqX8pQw59RR85SOCBJs50/G4ET6tHA1S+Nz0SWw==","salt":"UWP7yXChb0QpWy8jsscHXQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-06-18 21:04:48.311975	1	EXECUTED	8:bda77d94bf90182a1e30c24f1c155ec7	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.8.0	\N	\N	0280685838
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-06-18 21:04:48.337962	2	MARK_RAN	8:1ecb330f30986693d1cba9ab579fa219	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.8.0	\N	\N	0280685838
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-06-18 21:04:48.559517	3	EXECUTED	8:cb7ace19bc6d959f305605d255d4c843	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.8.0	\N	\N	0280685838
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-06-18 21:04:48.575567	4	EXECUTED	8:80230013e961310e6872e871be424a63	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.8.0	\N	\N	0280685838
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-06-18 21:04:49.070549	5	EXECUTED	8:67f4c20929126adc0c8e9bf48279d244	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.8.0	\N	\N	0280685838
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-06-18 21:04:49.077735	6	MARK_RAN	8:7311018b0b8179ce14628ab412bb6783	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.8.0	\N	\N	0280685838
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-06-18 21:04:49.461681	7	EXECUTED	8:037ba1216c3640f8785ee6b8e7c8e3c1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.8.0	\N	\N	0280685838
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-06-18 21:04:49.470278	8	MARK_RAN	8:7fe6ffe4af4df289b3157de32c624263	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.8.0	\N	\N	0280685838
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-06-18 21:04:49.482557	9	EXECUTED	8:9c136bc3187083a98745c7d03bc8a303	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.8.0	\N	\N	0280685838
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-06-18 21:04:50.015063	10	EXECUTED	8:b5f09474dca81fb56a97cf5b6553d331	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.8.0	\N	\N	0280685838
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-06-18 21:04:50.296434	11	EXECUTED	8:ca924f31bd2a3b219fdcfe78c82dacf4	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.8.0	\N	\N	0280685838
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-06-18 21:04:50.305977	12	MARK_RAN	8:8acad7483e106416bcfa6f3b824a16cd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.8.0	\N	\N	0280685838
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-06-18 21:04:50.344998	13	EXECUTED	8:9b1266d17f4f87c78226f5055408fd5e	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.8.0	\N	\N	0280685838
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-18 21:04:50.478477	14	EXECUTED	8:d80ec4ab6dbfe573550ff72396c7e910	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.8.0	\N	\N	0280685838
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-18 21:04:50.487352	15	MARK_RAN	8:d86eb172171e7c20b9c849b584d147b2	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0280685838
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-18 21:04:50.495531	16	MARK_RAN	8:5735f46f0fa60689deb0ecdc2a0dea22	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.8.0	\N	\N	0280685838
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-18 21:04:50.503702	17	EXECUTED	8:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.8.0	\N	\N	0280685838
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-06-18 21:04:50.796337	18	EXECUTED	8:5c1a8fd2014ac7fc43b90a700f117b23	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.8.0	\N	\N	0280685838
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-06-18 21:04:51.055217	19	EXECUTED	8:1f6c2c2dfc362aff4ed75b3f0ef6b331	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.8.0	\N	\N	0280685838
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-06-18 21:04:51.071276	20	EXECUTED	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.8.0	\N	\N	0280685838
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-18 21:04:54.398789	45	EXECUTED	8:a164ae073c56ffdbc98a615493609a52	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.8.0	\N	\N	0280685838
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-06-18 21:04:51.080544	21	MARK_RAN	8:9eb2ee1fa8ad1c5e426421a6f8fdfa6a	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.8.0	\N	\N	0280685838
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-06-18 21:04:51.088481	22	MARK_RAN	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.8.0	\N	\N	0280685838
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-06-18 21:04:51.182536	23	EXECUTED	8:d9fa18ffa355320395b86270680dd4fe	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.8.0	\N	\N	0280685838
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-06-18 21:04:51.205473	24	EXECUTED	8:90cff506fedb06141ffc1c71c4a1214c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.8.0	\N	\N	0280685838
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-06-18 21:04:51.214836	25	MARK_RAN	8:11a788aed4961d6d29c427c063af828c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.8.0	\N	\N	0280685838
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-06-18 21:04:51.547526	26	EXECUTED	8:a4218e51e1faf380518cce2af5d39b43	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.8.0	\N	\N	0280685838
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-06-18 21:04:52.082366	27	EXECUTED	8:d9e9a1bfaa644da9952456050f07bbdc	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.8.0	\N	\N	0280685838
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-06-18 21:04:52.091489	28	EXECUTED	8:d1bf991a6163c0acbfe664b615314505	update tableName=RESOURCE_SERVER_POLICY		\N	4.8.0	\N	\N	0280685838
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-06-18 21:04:52.556546	29	EXECUTED	8:88a743a1e87ec5e30bf603da68058a8c	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.8.0	\N	\N	0280685838
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-06-18 21:04:52.623177	30	EXECUTED	8:c5517863c875d325dea463d00ec26d7a	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.8.0	\N	\N	0280685838
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-06-18 21:04:52.715405	31	EXECUTED	8:ada8b4833b74a498f376d7136bc7d327	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.8.0	\N	\N	0280685838
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-06-18 21:04:52.728769	32	EXECUTED	8:b9b73c8ea7299457f99fcbb825c263ba	customChange		\N	4.8.0	\N	\N	0280685838
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-18 21:04:52.748111	33	EXECUTED	8:07724333e625ccfcfc5adc63d57314f3	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0280685838
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-18 21:04:52.757087	34	MARK_RAN	8:8b6fd445958882efe55deb26fc541a7b	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.8.0	\N	\N	0280685838
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-18 21:04:52.907774	35	EXECUTED	8:29b29cfebfd12600897680147277a9d7	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.8.0	\N	\N	0280685838
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-06-18 21:04:52.931792	36	EXECUTED	8:73ad77ca8fd0410c7f9f15a471fa52bc	addColumn tableName=REALM		\N	4.8.0	\N	\N	0280685838
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-18 21:04:53.006961	37	EXECUTED	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0280685838
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-06-18 21:04:53.051501	38	EXECUTED	8:27180251182e6c31846c2ddab4bc5781	addColumn tableName=FED_USER_CONSENT		\N	4.8.0	\N	\N	0280685838
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-06-18 21:04:53.07325	39	EXECUTED	8:d56f201bfcfa7a1413eb3e9bc02978f9	addColumn tableName=IDENTITY_PROVIDER		\N	4.8.0	\N	\N	0280685838
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-18 21:04:53.091263	40	MARK_RAN	8:91f5522bf6afdc2077dfab57fbd3455c	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.8.0	\N	\N	0280685838
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-18 21:04:53.099132	41	MARK_RAN	8:0f01b554f256c22caeb7d8aee3a1cdc8	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.8.0	\N	\N	0280685838
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-06-18 21:04:53.111574	42	EXECUTED	8:ab91cf9cee415867ade0e2df9651a947	customChange		\N	4.8.0	\N	\N	0280685838
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-18 21:04:54.366862	43	EXECUTED	8:ceac9b1889e97d602caf373eadb0d4b7	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.8.0	\N	\N	0280685838
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-06-18 21:04:54.382176	44	EXECUTED	8:84b986e628fe8f7fd8fd3c275c5259f2	addColumn tableName=USER_ENTITY		\N	4.8.0	\N	\N	0280685838
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-18 21:04:54.412894	46	EXECUTED	8:70a2b4f1f4bd4dbf487114bdb1810e64	customChange		\N	4.8.0	\N	\N	0280685838
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-18 21:04:54.42451	47	MARK_RAN	8:7be68b71d2f5b94b8df2e824f2860fa2	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.8.0	\N	\N	0280685838
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-18 21:04:54.667482	48	EXECUTED	8:bab7c631093c3861d6cf6144cd944982	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.8.0	\N	\N	0280685838
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-18 21:04:54.6823	49	EXECUTED	8:fa809ac11877d74d76fe40869916daad	addColumn tableName=REALM		\N	4.8.0	\N	\N	0280685838
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-06-18 21:04:55.050305	50	EXECUTED	8:fac23540a40208f5f5e326f6ceb4d291	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.8.0	\N	\N	0280685838
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-06-18 21:04:55.474634	51	EXECUTED	8:2612d1b8a97e2b5588c346e817307593	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.8.0	\N	\N	0280685838
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-06-18 21:04:55.49123	52	EXECUTED	8:9842f155c5db2206c88bcb5d1046e941	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0280685838
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-06-18 21:04:55.501773	53	EXECUTED	8:2e12e06e45498406db72d5b3da5bbc76	update tableName=REALM		\N	4.8.0	\N	\N	0280685838
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-06-18 21:04:55.509668	54	EXECUTED	8:33560e7c7989250c40da3abdabdc75a4	update tableName=CLIENT		\N	4.8.0	\N	\N	0280685838
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-18 21:04:55.557929	55	EXECUTED	8:87a8d8542046817a9107c7eb9cbad1cd	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.8.0	\N	\N	0280685838
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-18 21:04:55.583671	56	EXECUTED	8:3ea08490a70215ed0088c273d776311e	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.8.0	\N	\N	0280685838
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-18 21:04:55.733794	57	EXECUTED	8:2d56697c8723d4592ab608ce14b6ed68	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.8.0	\N	\N	0280685838
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-18 21:04:56.190728	58	EXECUTED	8:3e423e249f6068ea2bbe48bf907f9d86	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.8.0	\N	\N	0280685838
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-06-18 21:04:56.353131	59	EXECUTED	8:15cabee5e5df0ff099510a0fc03e4103	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.8.0	\N	\N	0280685838
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-06-18 21:04:56.384542	60	EXECUTED	8:4b80200af916ac54d2ffbfc47918ab0e	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.8.0	\N	\N	0280685838
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-06-18 21:04:56.409007	61	EXECUTED	8:66564cd5e168045d52252c5027485bbb	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.8.0	\N	\N	0280685838
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-06-18 21:04:56.442476	62	EXECUTED	8:1c7064fafb030222be2bd16ccf690f6f	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.8.0	\N	\N	0280685838
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-06-18 21:04:56.458847	63	EXECUTED	8:2de18a0dce10cdda5c7e65c9b719b6e5	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.8.0	\N	\N	0280685838
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-06-18 21:04:56.469326	64	EXECUTED	8:03e413dd182dcbd5c57e41c34d0ef682	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.8.0	\N	\N	0280685838
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-06-18 21:04:56.47964	65	EXECUTED	8:d27b42bb2571c18fbe3fe4e4fb7582a7	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.8.0	\N	\N	0280685838
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-06-18 21:04:56.567596	66	EXECUTED	8:698baf84d9fd0027e9192717c2154fb8	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.8.0	\N	\N	0280685838
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-06-18 21:04:56.600891	67	EXECUTED	8:ced8822edf0f75ef26eb51582f9a821a	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.8.0	\N	\N	0280685838
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-06-18 21:04:56.617493	68	EXECUTED	8:f0abba004cf429e8afc43056df06487d	addColumn tableName=REALM		\N	4.8.0	\N	\N	0280685838
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-06-18 21:04:56.668011	69	EXECUTED	8:6662f8b0b611caa359fcf13bf63b4e24	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.8.0	\N	\N	0280685838
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-06-18 21:04:56.684313	70	EXECUTED	8:9e6b8009560f684250bdbdf97670d39e	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.8.0	\N	\N	0280685838
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-06-18 21:04:56.709148	71	EXECUTED	8:4223f561f3b8dc655846562b57bb502e	addColumn tableName=RESOURCE_SERVER		\N	4.8.0	\N	\N	0280685838
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-18 21:04:56.734225	72	EXECUTED	8:215a31c398b363ce383a2b301202f29e	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.8.0	\N	\N	0280685838
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-18 21:04:56.751137	73	EXECUTED	8:83f7a671792ca98b3cbd3a1a34862d3d	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.8.0	\N	\N	0280685838
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-18 21:04:56.759615	74	MARK_RAN	8:f58ad148698cf30707a6efbdf8061aa7	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.8.0	\N	\N	0280685838
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-18 21:04:56.802666	75	EXECUTED	8:79e4fd6c6442980e58d52ffc3ee7b19c	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.8.0	\N	\N	0280685838
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-18 21:04:56.834513	76	EXECUTED	8:87af6a1e6d241ca4b15801d1f86a297d	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.8.0	\N	\N	0280685838
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-18 21:04:56.8509	77	EXECUTED	8:b44f8d9b7b6ea455305a6d72a200ed15	addColumn tableName=CLIENT		\N	4.8.0	\N	\N	0280685838
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-18 21:04:56.859692	78	MARK_RAN	8:2d8ed5aaaeffd0cb004c046b4a903ac5	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.8.0	\N	\N	0280685838
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-18 21:04:56.943035	79	EXECUTED	8:e290c01fcbc275326c511633f6e2acde	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.8.0	\N	\N	0280685838
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-18 21:04:56.951867	80	MARK_RAN	8:c9db8784c33cea210872ac2d805439f8	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.8.0	\N	\N	0280685838
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-18 21:04:56.993311	81	EXECUTED	8:95b676ce8fc546a1fcfb4c92fae4add5	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.8.0	\N	\N	0280685838
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-18 21:04:57.001952	82	MARK_RAN	8:38a6b2a41f5651018b1aca93a41401e5	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0280685838
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-18 21:04:57.07718	83	EXECUTED	8:3fb99bcad86a0229783123ac52f7609c	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0280685838
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-18 21:04:57.086468	84	MARK_RAN	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.8.0	\N	\N	0280685838
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-18 21:04:57.131943	85	EXECUTED	8:ab4f863f39adafd4c862f7ec01890abc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.8.0	\N	\N	0280685838
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-06-18 21:04:57.160043	86	EXECUTED	8:13c419a0eb336e91ee3a3bf8fda6e2a7	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.8.0	\N	\N	0280685838
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-06-18 21:04:57.184891	87	EXECUTED	8:e3fb1e698e0471487f51af1ed80fe3ac	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.8.0	\N	\N	0280685838
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-06-18 21:04:57.251675	88	EXECUTED	8:babadb686aab7b56562817e60bf0abd0	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.8.0	\N	\N	0280685838
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.268015	89	EXECUTED	8:72d03345fda8e2f17093d08801947773	addColumn tableName=REALM; customChange		\N	4.8.0	\N	\N	0280685838
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.286006	90	EXECUTED	8:61c9233951bd96ffecd9ba75f7d978a4	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.8.0	\N	\N	0280685838
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.326774	91	EXECUTED	8:ea82e6ad945cec250af6372767b25525	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0280685838
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.351607	92	EXECUTED	8:d3f4a33f41d960ddacd7e2ef30d126b3	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.8.0	\N	\N	0280685838
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.360378	93	MARK_RAN	8:1284a27fbd049d65831cb6fc07c8a783	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.8.0	\N	\N	0280685838
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.410448	94	EXECUTED	8:9d11b619db2ae27c25853b8a37cd0dea	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.8.0	\N	\N	0280685838
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.418859	95	MARK_RAN	8:3002bb3997451bb9e8bac5c5cd8d6327	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.8.0	\N	\N	0280685838
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-18 21:04:57.443406	96	EXECUTED	8:dfbee0d6237a23ef4ccbb7a4e063c163	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.8.0	\N	\N	0280685838
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-18 21:04:57.535379	97	EXECUTED	8:75f3e372df18d38c62734eebb986b960	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.8.0	\N	\N	0280685838
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-18 21:04:57.543814	98	MARK_RAN	8:7fee73eddf84a6035691512c85637eef	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0280685838
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-18 21:04:57.569895	99	MARK_RAN	8:7a11134ab12820f999fbf3bb13c3adc8	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0280685838
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-18 21:04:57.610232	100	EXECUTED	8:c0f6eaac1f3be773ffe54cb5b8482b70	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0280685838
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-18 21:04:57.618919	101	MARK_RAN	8:18186f0008b86e0f0f49b0c4d0e842ac	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0280685838
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-18 21:04:57.660396	102	EXECUTED	8:09c2780bcb23b310a7019d217dc7b433	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.8.0	\N	\N	0280685838
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-18 21:04:57.675724	103	EXECUTED	8:276a44955eab693c970a42880197fff2	customChange		\N	4.8.0	\N	\N	0280685838
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-06-18 21:04:57.702272	104	EXECUTED	8:ba8ee3b694d043f2bfc1a1079d0760d7	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.8.0	\N	\N	0280685838
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-06-18 21:04:57.743963	105	EXECUTED	8:5e06b1d75f5d17685485e610c2851b17	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.8.0	\N	\N	0280685838
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-06-18 21:04:57.785363	106	EXECUTED	8:4b80546c1dc550ac552ee7b24a4ab7c0	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.8.0	\N	\N	0280685838
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-06-18 21:04:57.798316	107	EXECUTED	8:af510cd1bb2ab6339c45372f3e491696	customChange		\N	4.8.0	\N	\N	0280685838
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-18 21:04:57.835226	108	EXECUTED	8:05c99fc610845ef66ee812b7921af0ef	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.8.0	\N	\N	0280685838
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-18 21:04:57.844012	109	MARK_RAN	8:314e803baf2f1ec315b3464e398b8247	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.8.0	\N	\N	0280685838
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-18 21:04:57.860272	110	EXECUTED	8:56e4677e7e12556f70b604c573840100	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.8.0	\N	\N	0280685838
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
27484249-b2b6-4f42-81db-28866ec26a77	012c4282-5f36-4291-a5b9-26a02853d775	f
27484249-b2b6-4f42-81db-28866ec26a77	1dd78784-ba97-4215-841c-4d8c1af20d90	t
27484249-b2b6-4f42-81db-28866ec26a77	21dabfb9-9365-486a-bf49-19a04aeec692	t
27484249-b2b6-4f42-81db-28866ec26a77	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa	t
27484249-b2b6-4f42-81db-28866ec26a77	29733772-4947-4728-9a12-e9b2de3bd0a5	f
27484249-b2b6-4f42-81db-28866ec26a77	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b	f
27484249-b2b6-4f42-81db-28866ec26a77	6879185d-004e-4aa7-827b-bcdc525be1eb	t
27484249-b2b6-4f42-81db-28866ec26a77	98855351-a294-4d1b-89f3-149c9c5fe267	t
27484249-b2b6-4f42-81db-28866ec26a77	22df6a73-be77-4043-bf2c-b9ede06836c1	f
27484249-b2b6-4f42-81db-28866ec26a77	64ca43a1-5da9-4054-9884-2bd5cfa2dd09	t
esdl-mapeditor	2cd84421-3e0f-44ed-bce3-f365cb6ecaf2	t
esdl-mapeditor	b29d72c1-0d0b-44b6-935f-247cb70b4f93	t
esdl-mapeditor	71641c61-88c7-421b-82c9-174a0e663347	t
esdl-mapeditor	eb4d7ce7-7ae6-4597-a384-ebcf870ad658	t
esdl-mapeditor	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2	t
esdl-mapeditor	a238a12d-c366-4492-8d87-1915dedd0b64	t
esdl-mapeditor	338168d6-6070-48f0-8c7b-b7d02089305f	t
esdl-mapeditor	fbec02ac-b60d-4ee8-86dd-ddac69aefe31	t
esdl-mapeditor	62e93726-e7be-4ff2-a8a0-427cb842cb09	f
esdl-mapeditor	42b21bf0-65df-4390-a003-c4f51bf006a3	f
esdl-mapeditor	d8105fab-c29b-42fb-9130-bd3062d87bc1	f
esdl-mapeditor	1e13f30e-663f-4409-874c-c2fdcab59306	f
esdl-mapeditor	0636469e-a1fe-448c-83ee-9d5e5a67c392	f
esdl-mapeditor	5d8dec81-b910-47d0-93ff-c7cd4f714eda	f
esdl-mapeditor	943b3db3-8ed4-420f-954c-3ea6e596a4c1	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
b797cae3-2fb5-48b4-8103-e087abf3d831	482140fe-404e-413e-b80b-cab5ff75d6d3
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
206a8618-5f25-4ab7-bb22-e0c4e15f7fc3	Organizations	 	esdl-mapeditor
9c5bdc77-ccaa-418e-9f1b-ded4908c84d5	TNO	206a8618-5f25-4ab7-bb22-e0c4e15f7fc3	esdl-mapeditor
8c673de8-097b-4677-b808-b06085309eba	Projects	 	esdl-mapeditor
482140fe-404e-413e-b80b-cab5ff75d6d3	Test	8c673de8-097b-4677-b808-b06085309eba	esdl-mapeditor
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
de8d7a77-af60-4af7-8dc0-a01d2aaf6c48	27484249-b2b6-4f42-81db-28866ec26a77	f	${role_default-roles}	default-roles-master	27484249-b2b6-4f42-81db-28866ec26a77	\N	\N
e9303386-0a07-4903-baef-fb4955045a31	27484249-b2b6-4f42-81db-28866ec26a77	f	${role_create-realm}	create-realm	27484249-b2b6-4f42-81db-28866ec26a77	\N	\N
3d7eb88c-305c-4882-8fd2-7147bafd17c1	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_create-client}	create-client	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
f28f59c9-a17f-4214-9fc7-1fd9b0807d37	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_view-realm}	view-realm	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
88c1fdaa-b6b0-4f5b-9759-5f531e740e25	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_view-users}	view-users	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
8ea6d134-ad6c-4e53-9580-b83d3b220618	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_view-clients}	view-clients	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
174a5f3e-0449-4bdb-af5f-65e7e96719bd	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_view-events}	view-events	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
d9898f30-4589-4833-a98b-cfe79e6996da	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_view-identity-providers}	view-identity-providers	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
016356b5-0b73-4c39-9d74-f810a8c30421	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_view-authorization}	view-authorization	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
be667ea4-0abb-4262-8b7a-fd208fe81be1	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_manage-realm}	manage-realm	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
b7256db8-a156-4e00-8c47-a76681ae806f	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_manage-users}	manage-users	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
43832dfd-9fb6-4543-b99e-c28c002ee380	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_manage-clients}	manage-clients	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
a52dd83b-564e-40cd-add4-9659448fbb55	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_manage-events}	manage-events	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
b1b4a56b-3c7e-4eb8-936c-a6a844bda9bf	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_manage-identity-providers}	manage-identity-providers	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
876a451c-782f-431c-b775-139d182d5922	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_manage-authorization}	manage-authorization	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
51de6a5c-3573-47dd-af3f-fe9fef204a9b	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_query-users}	query-users	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
310fe2bd-2098-46f8-b427-f37330edfa93	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_query-clients}	query-clients	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
2b0a0ef7-9bec-407d-9dfc-90577a012114	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_query-realms}	query-realms	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
0911a89f-8275-4bb6-960b-4252db55883e	27484249-b2b6-4f42-81db-28866ec26a77	f	${role_admin}	admin	27484249-b2b6-4f42-81db-28866ec26a77	\N	\N
8088fef0-ac21-4ee9-ab29-fd81616fc59d	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_query-groups}	query-groups	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
f6037888-386e-4a83-8819-5380633b80dd	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_view-profile}	view-profile	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
1e7dd160-cdfe-4dff-a4af-d9284466ee09	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_manage-account}	manage-account	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
5cce4307-41d3-4ce6-ae28-f1885e5ebe7d	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_manage-account-links}	manage-account-links	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
8745d11d-652a-4d94-81d4-1fb9054a4cc9	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_view-applications}	view-applications	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
3b33b1bd-5e1f-4fb5-90a2-c34e908ad7d7	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_view-consent}	view-consent	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
c5a4b87c-6487-4560-bc52-aea187657ba2	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_manage-consent}	manage-consent	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
e539f317-c351-427b-94ee-a73428a6076a	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_view-groups}	view-groups	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
664bfbdf-6e0d-4f12-86aa-62b62a63c5c6	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	t	${role_delete-account}	delete-account	27484249-b2b6-4f42-81db-28866ec26a77	9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	\N
1e917e37-84dc-4468-aef6-b064c614efaa	3d2181fc-5614-4fcb-831a-4180804c229b	t	${role_read-token}	read-token	27484249-b2b6-4f42-81db-28866ec26a77	3d2181fc-5614-4fcb-831a-4180804c229b	\N
0548a9d8-c2bf-4adb-a330-bac73d29c243	d8c1eb85-609a-4124-a680-2004c04d18a8	t	${role_impersonation}	impersonation	27484249-b2b6-4f42-81db-28866ec26a77	d8c1eb85-609a-4124-a680-2004c04d18a8	\N
696cdfe5-9ca8-4d43-bf9a-37d3c55bb51c	27484249-b2b6-4f42-81db-28866ec26a77	f	${role_offline-access}	offline_access	27484249-b2b6-4f42-81db-28866ec26a77	\N	\N
a6cbcb2a-526a-48f3-9762-364860ed67bd	27484249-b2b6-4f42-81db-28866ec26a77	f	${role_uma_authorization}	uma_authorization	27484249-b2b6-4f42-81db-28866ec26a77	\N	\N
d1510da4-d458-4d2a-9cc6-ae62d900ed7e	esdl-mapeditor	f	${role_default-roles}	default-roles-esdl-mapeditor	esdl-mapeditor	\N	\N
7ee203c8-9329-4374-976c-5fd01282ae96	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_create-client}	create-client	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
e9624eb4-f121-491d-a9c3-e519d09394bd	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_view-realm}	view-realm	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
e26270fb-4930-4ced-b234-1135a1b8f608	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_view-users}	view-users	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
ab058e32-17fb-4a4c-b740-341ef4694ad2	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_view-clients}	view-clients	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
3aa484e8-a49a-4425-865e-74c26c69d092	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_view-events}	view-events	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
ca23f832-91c4-4c05-84ba-0bcecfb1b0ab	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_view-identity-providers}	view-identity-providers	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
8b7d1b7a-7bf3-4b39-a025-472e793f9386	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_view-authorization}	view-authorization	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
db89105d-f183-4a0c-938c-0e2628a34e31	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_manage-realm}	manage-realm	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
f038ba1b-9e36-4d8f-a1d5-658364e83110	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_manage-users}	manage-users	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
e5981d58-57b4-425a-844f-97383e91628c	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_manage-clients}	manage-clients	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
1aca210a-d49f-416d-b8c7-09cc055e11c8	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_manage-events}	manage-events	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
8be0e294-6fdd-4bd0-a89a-df5b1de4a3ce	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_manage-identity-providers}	manage-identity-providers	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
ca08d7a2-dfac-4137-96cc-1f4d6ac72d23	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_manage-authorization}	manage-authorization	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
c7ee3e24-315a-485e-a7ba-6e0258b62073	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_query-users}	query-users	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
7a49202f-aa76-4ace-91e2-1ac9602e97cf	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_query-clients}	query-clients	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
a311004f-4ed6-4e77-9f87-78a7bbfc6083	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_query-realms}	query-realms	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
4cdfa079-3de3-40a8-bf49-b6d982620bfc	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_query-groups}	query-groups	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
0ad83d6d-c9f0-4241-9da8-fe8a02a2e6bf	esdl-mapeditor	f	${role_offline-access}	offline_access	esdl-mapeditor	\N	\N
b797cae3-2fb5-48b4-8103-e087abf3d831	esdl-mapeditor	f	Role that allows somebody to access the CDO-based ESDL Drive	cdo_read	esdl-mapeditor	\N	\N
b1427348-28b2-42be-8fc4-6016e39387ae	esdl-mapeditor	f	\N	uma_authorization	esdl-mapeditor	\N	\N
523320f1-95a5-49ce-9f4a-249a78f68265	4d2874c8-1177-4cd4-991f-9a62ce88db03	t	Admin rights for the mapeditor, e.g. changing system WMS layers	mapeditor-admin	esdl-mapeditor	4d2874c8-1177-4cd4-991f-9a62ce88db03	\N
b39c9570-2628-4d8d-ab48-b71bdcce1a1a	4d2874c8-1177-4cd4-991f-9a62ce88db03	t	\N	uma_protection	esdl-mapeditor	4d2874c8-1177-4cd4-991f-9a62ce88db03	\N
b5df27f4-12b4-4138-bf1b-0c21f7793342	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_view-clients}	view-clients	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
2deb5e67-19e9-4a5c-9009-3a31aceb38ec	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_view-authorization}	view-authorization	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
3886d03b-97bc-4d0e-b0ab-f30d5281994d	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_view-users}	view-users	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
6b3509fb-90ad-401b-8470-72ba6f93ee61	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_query-groups}	query-groups	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
5e10ce66-93d4-4c9c-8659-9e4480aac309	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_create-client}	create-client	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
277d1d15-1034-4a91-9cb8-275e8aee0354	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_view-events}	view-events	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
bd874f35-c7f5-4881-8d77-0e8595885791	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_manage-clients}	manage-clients	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
c4d5e6e6-4c90-45ef-823a-12c8a90f6853	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_manage-identity-providers}	manage-identity-providers	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
639ab8c1-b414-4ef7-8cd8-d280e96570ff	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_query-clients}	query-clients	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
4d66ce10-9a8b-4c6f-8dc6-51589161434a	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_manage-realm}	manage-realm	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
d74c8164-1de4-46ab-8a92-a071389a7aba	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_manage-users}	manage-users	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
589ca649-6453-425a-a705-04c43ec4650c	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_impersonation}	impersonation	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
d3d57617-1182-4303-bd79-dce7d1185f98	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_realm-admin}	realm-admin	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
30d570b8-9e3e-46ef-b150-183fdf7b595d	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_manage-authorization}	manage-authorization	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
da180e64-4334-489d-a889-329019ade8e3	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_view-identity-providers}	view-identity-providers	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
ce237498-d919-4c64-8aef-2129fa6eebb4	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_view-realm}	view-realm	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
2d5d92fe-315b-4033-b04d-22a54704abfe	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_query-realms}	query-realms	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
5d61563a-1612-452b-b4c3-d99e631c0b66	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_manage-events}	manage-events	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
9ca6f75d-bb84-428c-ba3a-61b94a2d1feb	0eb5ebad-abba-4f01-b2af-56c4874059c4	t	${role_query-users}	query-users	esdl-mapeditor	0eb5ebad-abba-4f01-b2af-56c4874059c4	\N
1ca04ae7-fe60-41e9-9b86-1d53afbbd037	c335a38b-9f6c-4256-bc10-43561bb80698	t	\N	uma_protection	esdl-mapeditor	c335a38b-9f6c-4256-bc10-43561bb80698	\N
10168b19-0855-40dc-afda-06a5fbb8561b	a81afdbf-f130-4f26-bafd-73e08372e558	t	${role_read-token}	read-token	esdl-mapeditor	a81afdbf-f130-4f26-bafd-73e08372e558	\N
eaff806d-886b-48d3-bebc-35a3f2c1322b	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_view-applications}	view-applications	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
eaec7753-cbdb-4cc0-a20c-c2cdf87ee2d8	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_manage-consent}	manage-consent	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
d4eb6018-6682-4096-9f8a-e02c142beb96	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_view-profile}	view-profile	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
a1f7eb1d-8611-4529-9710-c85994fafaaf	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_manage-account}	manage-account	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
9b0cec72-43f3-4972-85e6-299a5228795f	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_view-consent}	view-consent	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
5d3b8c97-ef8a-416b-9c2c-f9d248aee49d	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_manage-account-links}	manage-account-links	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
b4b2ee6c-d2b3-4acf-8afc-fa60cafc6c37	603d98fb-fd82-446a-aec4-03abc7a0ebd4	t	\N	Admin	esdl-mapeditor	603d98fb-fd82-446a-aec4-03abc7a0ebd4	\N
21bbb52c-551b-41a8-b8ca-e0f6c113a69b	603d98fb-fd82-446a-aec4-03abc7a0ebd4	t	\N	Editor	esdl-mapeditor	603d98fb-fd82-446a-aec4-03abc7a0ebd4	\N
4cd94d4c-d544-4b5a-9d70-d009766387a3	603d98fb-fd82-446a-aec4-03abc7a0ebd4	t	\N	uma_protection	esdl-mapeditor	603d98fb-fd82-446a-aec4-03abc7a0ebd4	\N
e3d70c03-60d3-4403-9d57-e3005ef88a7c	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	t	${role_impersonation}	impersonation	27484249-b2b6-4f42-81db-28866ec26a77	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	\N
0b0fa86f-4a29-4fc8-a827-2c97a93eff45	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_delete-account}	delete-account	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
e835f1ba-29eb-4c8f-87fd-619625a48e1c	043f3b1d-595d-4fe1-b984-7fc13582cdf2	t	${role_view-groups}	view-groups	esdl-mapeditor	043f3b1d-595d-4fe1-b984-7fc13582cdf2	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migration_model (id, version, update_time) FROM stdin;
pg5wm	20.0.3	1750280698
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
4c0875e7-bde4-435b-9475-7501313028da	audience resolve	openid-connect	oidc-audience-resolve-mapper	3685fc1f-d0a1-488f-b4b6-6085c430766a	\N
9bd12e08-7659-4a92-b2da-62a04ceee169	locale	openid-connect	oidc-usermodel-attribute-mapper	98188f0b-9771-4045-a9d2-36e13ad07ec6	\N
bcbdeaa0-b95a-4339-9642-880fbb8aa9ea	role list	saml	saml-role-list-mapper	\N	1dd78784-ba97-4215-841c-4d8c1af20d90
9cd14199-32ef-4dd3-91d3-2bef3217593f	full name	openid-connect	oidc-full-name-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
fc02633c-c798-44cc-bb1f-ca0e49fd3ebb	family name	openid-connect	oidc-usermodel-property-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
4e7b4a7e-95cd-4c94-b0e0-cbe4f6537cd9	given name	openid-connect	oidc-usermodel-property-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
e5cb9195-2c77-4d45-af7c-96a7102b0c2f	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
b1d5d91c-f088-47f4-861e-78489ab3a128	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
7b19a00a-b1ee-4bdd-b4cf-e67ebe60d186	username	openid-connect	oidc-usermodel-property-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
119eb562-5f9f-4308-80cd-7770acdd4bcf	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
af889bf0-3ed3-496a-8339-6d1250b5ea78	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
0fdd05cc-f29a-4008-943d-c696e4643899	website	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
e4d7ff8e-baa2-4eec-a3f0-565b8d772712	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
0f857f53-c58a-4a0e-8e9c-f0712d3f7cfa	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
f1591017-2be7-45c7-a8e4-69665af0b968	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
d8aab124-03b0-487e-a7ce-d66573892101	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
a30bebfa-7f5a-40d7-9e7c-eb6b007bfbd8	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	21dabfb9-9365-486a-bf49-19a04aeec692
3fc082e0-46ae-4ef3-9881-3b0a30b1d125	email	openid-connect	oidc-usermodel-property-mapper	\N	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa
9687dc39-e7a7-44f8-bea4-fdfcd8b7f5c1	email verified	openid-connect	oidc-usermodel-property-mapper	\N	1c5cb8d9-67b2-4433-a672-2a4ae1d088aa
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	address	openid-connect	oidc-address-mapper	\N	29733772-4947-4728-9a12-e9b2de3bd0a5
233e12b4-78af-401c-92f3-c5e7f818f4a9	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b
13dcfd71-5fcf-4b2a-afce-99bf8eb4fd97	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	a9fef8e9-d998-401c-9adb-b6c3ca1fe97b
ca52ab62-d4ce-4238-b034-4e0853cb5bb1	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	6879185d-004e-4aa7-827b-bcdc525be1eb
9e434c4f-4e51-4b0a-a83a-e8934d5c28cd	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	6879185d-004e-4aa7-827b-bcdc525be1eb
71067541-dacc-4dde-aca3-93d75f45907c	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	6879185d-004e-4aa7-827b-bcdc525be1eb
1bbc6db8-731a-4517-b238-3bbcd0940f58	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	98855351-a294-4d1b-89f3-149c9c5fe267
2b8c269b-eb63-4589-9995-6bfe46831851	upn	openid-connect	oidc-usermodel-property-mapper	\N	22df6a73-be77-4043-bf2c-b9ede06836c1
faf9419f-8ba3-48e4-a7c8-436098108ea4	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	22df6a73-be77-4043-bf2c-b9ede06836c1
b23cc537-ff30-4d80-a40b-96d12d0162c3	acr loa level	openid-connect	oidc-acr-mapper	\N	64ca43a1-5da9-4054-9884-2bd5cfa2dd09
a3ae5c78-029a-46cb-8add-42f85a29720d	role list	saml	saml-role-list-mapper	\N	2cd84421-3e0f-44ed-bce3-f365cb6ecaf2
e0ff97ad-7797-43f7-ab5d-06aa2aa065c6	user_group_path	openid-connect	oidc-group-membership-mapper	\N	fbec02ac-b60d-4ee8-86dd-ddac69aefe31
fc6fd328-d6f6-4549-8bb1-3f8ea250373b	esdl-mapeditor-protocol-mapper	openid-connect	oidc-audience-mapper	\N	5d8dec81-b910-47d0-93ff-c7cd4f714eda
83b21a94-8eb3-4540-a45a-0a99b5113dec	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	a238a12d-c366-4492-8d87-1915dedd0b64
72962421-b1f3-418e-a363-752fe8e1a53a	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
b56d46db-6948-4cd5-ad06-90e9922ce90d	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
6aed1ed2-19f2-4927-8130-cf749e107dcf	full name	openid-connect	oidc-full-name-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
d7352bf5-9d78-4a4a-83c8-6cd1a7f08f03	family name	openid-connect	oidc-usermodel-property-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
3ec0e55a-8a9a-45a7-93cc-878874ea7a44	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
90af5992-e42e-446e-a878-63df540c49b2	username	openid-connect	oidc-usermodel-property-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
85e2ab4c-b02c-42cc-9953-b882c83508a9	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
94e43432-ed88-40e6-8c95-a216d7877733	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
f8be96e6-5079-4276-b2e2-865d01ad0957	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
ca789e92-b182-49b1-9bb5-3865a9594216	given name	openid-connect	oidc-usermodel-property-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
8a2ca18a-5f7e-461d-be4a-8a6fb4af5648	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
550d2a62-5210-4ab8-a198-afc6bed52866	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
b6f47d77-e670-4358-8788-2c36e4714802	website	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
e15bfa9b-544c-4cac-a850-41b4f8ca7b41	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	b29d72c1-0d0b-44b6-935f-247cb70b4f93
ba25df63-647d-4b53-9ea8-f1b5b17ab051	email verified	openid-connect	oidc-usermodel-property-mapper	\N	71641c61-88c7-421b-82c9-174a0e663347
ecbaafe9-11b5-4b56-a4ac-53b5476f056d	email	openid-connect	oidc-usermodel-property-mapper	\N	71641c61-88c7-421b-82c9-174a0e663347
3aeda11a-6139-4cdc-984f-82f68618469e	address	openid-connect	oidc-address-mapper	\N	42b21bf0-65df-4390-a003-c4f51bf006a3
b7fc80f6-4ba7-4408-af5d-06ed76dd65ee	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	d8105fab-c29b-42fb-9130-bd3062d87bc1
3b65dbfa-5d45-4551-a4d5-0e70e00f3b31	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	d8105fab-c29b-42fb-9130-bd3062d87bc1
b5b7559a-6630-48fd-8f9f-1b10790927c6	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	eb4d7ce7-7ae6-4597-a384-ebcf870ad658
215bd997-5575-4180-a4fc-3bca00239f85	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	eb4d7ce7-7ae6-4597-a384-ebcf870ad658
80d7aba7-6151-4485-99a3-a41ef3766767	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	eb4d7ce7-7ae6-4597-a384-ebcf870ad658
5e87cf45-1b49-4ba5-9d7a-4146d8f899c6	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	92ff8a3b-2e1c-4c71-b19d-10e5eb3beee2
942ca4ef-01e2-497d-8ce3-2cca357f35eb	upn	openid-connect	oidc-usermodel-property-mapper	\N	1e13f30e-663f-4409-874c-c2fdcab59306
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	1e13f30e-663f-4409-874c-c2fdcab59306
3abd8ade-e674-4364-8e87-c9f490c300dc	user_group	openid-connect	oidc-group-membership-mapper	\N	338168d6-6070-48f0-8c7b-b7d02089305f
d934658e-7f8f-456f-8822-d6121e6ec88c	audience resolve	openid-connect	oidc-audience-resolve-mapper	295b1d84-f59f-4336-b864-6fb3cf140de1	\N
f4053176-3f37-4dcb-b99a-eaa6c7cc576f	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	c335a38b-9f6c-4256-bc10-43561bb80698	\N
6f7f2746-4ebf-4641-b614-f44cc62b4a30	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	c335a38b-9f6c-4256-bc10-43561bb80698	\N
315f78da-9a8a-4f92-934c-e6de44246b80	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	c335a38b-9f6c-4256-bc10-43561bb80698	\N
e11617c6-5131-424a-8e7b-3292ce925d5a	groups	openid-connect	oidc-usermodel-realm-role-mapper	c335a38b-9f6c-4256-bc10-43561bb80698	\N
4df02771-4cab-4d3e-9d55-f6c0854405f3	role	openid-connect	oidc-usermodel-attribute-mapper	4d2874c8-1177-4cd4-991f-9a62ce88db03	\N
932a8954-57c7-4c3d-9240-10f6e3323c77	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	4d2874c8-1177-4cd4-991f-9a62ce88db03	\N
d3af927f-e850-447f-8816-8ad8f530e683	client roles	openid-connect	oidc-usermodel-client-role-mapper	4d2874c8-1177-4cd4-991f-9a62ce88db03	\N
00dd46a7-162c-4daf-b41f-2717d44b56a3	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	4d2874c8-1177-4cd4-991f-9a62ce88db03	\N
a26c720f-7075-49d3-bec7-447cd4555420	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	4d2874c8-1177-4cd4-991f-9a62ce88db03	\N
27914c0b-5ad2-44c6-a7c8-e2472269053f	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	603d98fb-fd82-446a-aec4-03abc7a0ebd4	\N
7dda5348-5d64-4e25-b41b-25ddd0b84121	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	603d98fb-fd82-446a-aec4-03abc7a0ebd4	\N
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	grafana_role_in_userinfo	openid-connect	oidc-usermodel-client-role-mapper	603d98fb-fd82-446a-aec4-03abc7a0ebd4	\N
0947ecbf-b0ee-45d6-9ee7-a0c81c567186	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	603d98fb-fd82-446a-aec4-03abc7a0ebd4	\N
421d4f07-c4fa-4e07-ac3d-a6e1a442ab80	locale	openid-connect	oidc-usermodel-attribute-mapper	ee1eff39-a727-46a3-9d18-0600e356d847	\N
3a5028b8-fec4-44c6-bce5-4bce39af2ba6	acr loa level	openid-connect	oidc-acr-mapper	\N	943b3db3-8ed4-420f-954c-3ea6e596a4c1
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
9bd12e08-7659-4a92-b2da-62a04ceee169	true	userinfo.token.claim
9bd12e08-7659-4a92-b2da-62a04ceee169	locale	user.attribute
9bd12e08-7659-4a92-b2da-62a04ceee169	true	id.token.claim
9bd12e08-7659-4a92-b2da-62a04ceee169	true	access.token.claim
9bd12e08-7659-4a92-b2da-62a04ceee169	locale	claim.name
9bd12e08-7659-4a92-b2da-62a04ceee169	String	jsonType.label
bcbdeaa0-b95a-4339-9642-880fbb8aa9ea	false	single
bcbdeaa0-b95a-4339-9642-880fbb8aa9ea	Basic	attribute.nameformat
bcbdeaa0-b95a-4339-9642-880fbb8aa9ea	Role	attribute.name
0f857f53-c58a-4a0e-8e9c-f0712d3f7cfa	true	userinfo.token.claim
0f857f53-c58a-4a0e-8e9c-f0712d3f7cfa	birthdate	user.attribute
0f857f53-c58a-4a0e-8e9c-f0712d3f7cfa	true	id.token.claim
0f857f53-c58a-4a0e-8e9c-f0712d3f7cfa	true	access.token.claim
0f857f53-c58a-4a0e-8e9c-f0712d3f7cfa	birthdate	claim.name
0f857f53-c58a-4a0e-8e9c-f0712d3f7cfa	String	jsonType.label
0fdd05cc-f29a-4008-943d-c696e4643899	true	userinfo.token.claim
0fdd05cc-f29a-4008-943d-c696e4643899	website	user.attribute
0fdd05cc-f29a-4008-943d-c696e4643899	true	id.token.claim
0fdd05cc-f29a-4008-943d-c696e4643899	true	access.token.claim
0fdd05cc-f29a-4008-943d-c696e4643899	website	claim.name
0fdd05cc-f29a-4008-943d-c696e4643899	String	jsonType.label
119eb562-5f9f-4308-80cd-7770acdd4bcf	true	userinfo.token.claim
119eb562-5f9f-4308-80cd-7770acdd4bcf	profile	user.attribute
119eb562-5f9f-4308-80cd-7770acdd4bcf	true	id.token.claim
119eb562-5f9f-4308-80cd-7770acdd4bcf	true	access.token.claim
119eb562-5f9f-4308-80cd-7770acdd4bcf	profile	claim.name
119eb562-5f9f-4308-80cd-7770acdd4bcf	String	jsonType.label
4e7b4a7e-95cd-4c94-b0e0-cbe4f6537cd9	true	userinfo.token.claim
4e7b4a7e-95cd-4c94-b0e0-cbe4f6537cd9	firstName	user.attribute
4e7b4a7e-95cd-4c94-b0e0-cbe4f6537cd9	true	id.token.claim
4e7b4a7e-95cd-4c94-b0e0-cbe4f6537cd9	true	access.token.claim
4e7b4a7e-95cd-4c94-b0e0-cbe4f6537cd9	given_name	claim.name
4e7b4a7e-95cd-4c94-b0e0-cbe4f6537cd9	String	jsonType.label
7b19a00a-b1ee-4bdd-b4cf-e67ebe60d186	true	userinfo.token.claim
7b19a00a-b1ee-4bdd-b4cf-e67ebe60d186	username	user.attribute
7b19a00a-b1ee-4bdd-b4cf-e67ebe60d186	true	id.token.claim
7b19a00a-b1ee-4bdd-b4cf-e67ebe60d186	true	access.token.claim
7b19a00a-b1ee-4bdd-b4cf-e67ebe60d186	preferred_username	claim.name
7b19a00a-b1ee-4bdd-b4cf-e67ebe60d186	String	jsonType.label
9cd14199-32ef-4dd3-91d3-2bef3217593f	true	userinfo.token.claim
9cd14199-32ef-4dd3-91d3-2bef3217593f	true	id.token.claim
9cd14199-32ef-4dd3-91d3-2bef3217593f	true	access.token.claim
a30bebfa-7f5a-40d7-9e7c-eb6b007bfbd8	true	userinfo.token.claim
a30bebfa-7f5a-40d7-9e7c-eb6b007bfbd8	updatedAt	user.attribute
a30bebfa-7f5a-40d7-9e7c-eb6b007bfbd8	true	id.token.claim
a30bebfa-7f5a-40d7-9e7c-eb6b007bfbd8	true	access.token.claim
a30bebfa-7f5a-40d7-9e7c-eb6b007bfbd8	updated_at	claim.name
a30bebfa-7f5a-40d7-9e7c-eb6b007bfbd8	long	jsonType.label
af889bf0-3ed3-496a-8339-6d1250b5ea78	true	userinfo.token.claim
af889bf0-3ed3-496a-8339-6d1250b5ea78	picture	user.attribute
af889bf0-3ed3-496a-8339-6d1250b5ea78	true	id.token.claim
af889bf0-3ed3-496a-8339-6d1250b5ea78	true	access.token.claim
af889bf0-3ed3-496a-8339-6d1250b5ea78	picture	claim.name
af889bf0-3ed3-496a-8339-6d1250b5ea78	String	jsonType.label
b1d5d91c-f088-47f4-861e-78489ab3a128	true	userinfo.token.claim
b1d5d91c-f088-47f4-861e-78489ab3a128	nickname	user.attribute
b1d5d91c-f088-47f4-861e-78489ab3a128	true	id.token.claim
b1d5d91c-f088-47f4-861e-78489ab3a128	true	access.token.claim
b1d5d91c-f088-47f4-861e-78489ab3a128	nickname	claim.name
b1d5d91c-f088-47f4-861e-78489ab3a128	String	jsonType.label
d8aab124-03b0-487e-a7ce-d66573892101	true	userinfo.token.claim
d8aab124-03b0-487e-a7ce-d66573892101	locale	user.attribute
d8aab124-03b0-487e-a7ce-d66573892101	true	id.token.claim
d8aab124-03b0-487e-a7ce-d66573892101	true	access.token.claim
d8aab124-03b0-487e-a7ce-d66573892101	locale	claim.name
d8aab124-03b0-487e-a7ce-d66573892101	String	jsonType.label
e4d7ff8e-baa2-4eec-a3f0-565b8d772712	true	userinfo.token.claim
e4d7ff8e-baa2-4eec-a3f0-565b8d772712	gender	user.attribute
e4d7ff8e-baa2-4eec-a3f0-565b8d772712	true	id.token.claim
e4d7ff8e-baa2-4eec-a3f0-565b8d772712	true	access.token.claim
e4d7ff8e-baa2-4eec-a3f0-565b8d772712	gender	claim.name
e4d7ff8e-baa2-4eec-a3f0-565b8d772712	String	jsonType.label
e5cb9195-2c77-4d45-af7c-96a7102b0c2f	true	userinfo.token.claim
e5cb9195-2c77-4d45-af7c-96a7102b0c2f	middleName	user.attribute
e5cb9195-2c77-4d45-af7c-96a7102b0c2f	true	id.token.claim
e5cb9195-2c77-4d45-af7c-96a7102b0c2f	true	access.token.claim
e5cb9195-2c77-4d45-af7c-96a7102b0c2f	middle_name	claim.name
e5cb9195-2c77-4d45-af7c-96a7102b0c2f	String	jsonType.label
f1591017-2be7-45c7-a8e4-69665af0b968	true	userinfo.token.claim
f1591017-2be7-45c7-a8e4-69665af0b968	zoneinfo	user.attribute
f1591017-2be7-45c7-a8e4-69665af0b968	true	id.token.claim
f1591017-2be7-45c7-a8e4-69665af0b968	true	access.token.claim
f1591017-2be7-45c7-a8e4-69665af0b968	zoneinfo	claim.name
f1591017-2be7-45c7-a8e4-69665af0b968	String	jsonType.label
fc02633c-c798-44cc-bb1f-ca0e49fd3ebb	true	userinfo.token.claim
fc02633c-c798-44cc-bb1f-ca0e49fd3ebb	lastName	user.attribute
fc02633c-c798-44cc-bb1f-ca0e49fd3ebb	true	id.token.claim
fc02633c-c798-44cc-bb1f-ca0e49fd3ebb	true	access.token.claim
fc02633c-c798-44cc-bb1f-ca0e49fd3ebb	family_name	claim.name
fc02633c-c798-44cc-bb1f-ca0e49fd3ebb	String	jsonType.label
3fc082e0-46ae-4ef3-9881-3b0a30b1d125	true	userinfo.token.claim
3fc082e0-46ae-4ef3-9881-3b0a30b1d125	email	user.attribute
3fc082e0-46ae-4ef3-9881-3b0a30b1d125	true	id.token.claim
3fc082e0-46ae-4ef3-9881-3b0a30b1d125	true	access.token.claim
3fc082e0-46ae-4ef3-9881-3b0a30b1d125	email	claim.name
3fc082e0-46ae-4ef3-9881-3b0a30b1d125	String	jsonType.label
9687dc39-e7a7-44f8-bea4-fdfcd8b7f5c1	true	userinfo.token.claim
9687dc39-e7a7-44f8-bea4-fdfcd8b7f5c1	emailVerified	user.attribute
9687dc39-e7a7-44f8-bea4-fdfcd8b7f5c1	true	id.token.claim
9687dc39-e7a7-44f8-bea4-fdfcd8b7f5c1	true	access.token.claim
9687dc39-e7a7-44f8-bea4-fdfcd8b7f5c1	email_verified	claim.name
9687dc39-e7a7-44f8-bea4-fdfcd8b7f5c1	boolean	jsonType.label
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	formatted	user.attribute.formatted
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	country	user.attribute.country
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	postal_code	user.attribute.postal_code
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	true	userinfo.token.claim
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	street	user.attribute.street
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	true	id.token.claim
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	region	user.attribute.region
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	true	access.token.claim
7d384d90-1a3d-4ea9-8bb1-8a7456a4d374	locality	user.attribute.locality
13dcfd71-5fcf-4b2a-afce-99bf8eb4fd97	true	userinfo.token.claim
13dcfd71-5fcf-4b2a-afce-99bf8eb4fd97	phoneNumberVerified	user.attribute
13dcfd71-5fcf-4b2a-afce-99bf8eb4fd97	true	id.token.claim
13dcfd71-5fcf-4b2a-afce-99bf8eb4fd97	true	access.token.claim
13dcfd71-5fcf-4b2a-afce-99bf8eb4fd97	phone_number_verified	claim.name
13dcfd71-5fcf-4b2a-afce-99bf8eb4fd97	boolean	jsonType.label
233e12b4-78af-401c-92f3-c5e7f818f4a9	true	userinfo.token.claim
233e12b4-78af-401c-92f3-c5e7f818f4a9	phoneNumber	user.attribute
233e12b4-78af-401c-92f3-c5e7f818f4a9	true	id.token.claim
233e12b4-78af-401c-92f3-c5e7f818f4a9	true	access.token.claim
233e12b4-78af-401c-92f3-c5e7f818f4a9	phone_number	claim.name
233e12b4-78af-401c-92f3-c5e7f818f4a9	String	jsonType.label
9e434c4f-4e51-4b0a-a83a-e8934d5c28cd	true	multivalued
9e434c4f-4e51-4b0a-a83a-e8934d5c28cd	foo	user.attribute
9e434c4f-4e51-4b0a-a83a-e8934d5c28cd	true	access.token.claim
9e434c4f-4e51-4b0a-a83a-e8934d5c28cd	resource_access.${client_id}.roles	claim.name
9e434c4f-4e51-4b0a-a83a-e8934d5c28cd	String	jsonType.label
ca52ab62-d4ce-4238-b034-4e0853cb5bb1	true	multivalued
ca52ab62-d4ce-4238-b034-4e0853cb5bb1	foo	user.attribute
ca52ab62-d4ce-4238-b034-4e0853cb5bb1	true	access.token.claim
ca52ab62-d4ce-4238-b034-4e0853cb5bb1	realm_access.roles	claim.name
ca52ab62-d4ce-4238-b034-4e0853cb5bb1	String	jsonType.label
2b8c269b-eb63-4589-9995-6bfe46831851	true	userinfo.token.claim
2b8c269b-eb63-4589-9995-6bfe46831851	username	user.attribute
2b8c269b-eb63-4589-9995-6bfe46831851	true	id.token.claim
2b8c269b-eb63-4589-9995-6bfe46831851	true	access.token.claim
2b8c269b-eb63-4589-9995-6bfe46831851	upn	claim.name
2b8c269b-eb63-4589-9995-6bfe46831851	String	jsonType.label
faf9419f-8ba3-48e4-a7c8-436098108ea4	true	multivalued
faf9419f-8ba3-48e4-a7c8-436098108ea4	foo	user.attribute
faf9419f-8ba3-48e4-a7c8-436098108ea4	true	id.token.claim
faf9419f-8ba3-48e4-a7c8-436098108ea4	true	access.token.claim
faf9419f-8ba3-48e4-a7c8-436098108ea4	groups	claim.name
faf9419f-8ba3-48e4-a7c8-436098108ea4	String	jsonType.label
b23cc537-ff30-4d80-a40b-96d12d0162c3	true	id.token.claim
b23cc537-ff30-4d80-a40b-96d12d0162c3	true	access.token.claim
a3ae5c78-029a-46cb-8add-42f85a29720d	false	single
a3ae5c78-029a-46cb-8add-42f85a29720d	Basic	attribute.nameformat
a3ae5c78-029a-46cb-8add-42f85a29720d	Role	attribute.name
e0ff97ad-7797-43f7-ab5d-06aa2aa065c6	true	full.path
e0ff97ad-7797-43f7-ab5d-06aa2aa065c6	true	id.token.claim
e0ff97ad-7797-43f7-ab5d-06aa2aa065c6	true	access.token.claim
e0ff97ad-7797-43f7-ab5d-06aa2aa065c6	user_group_path	claim.name
e0ff97ad-7797-43f7-ab5d-06aa2aa065c6	true	userinfo.token.claim
fc6fd328-d6f6-4549-8bb1-3f8ea250373b	esdl-mapeditor	included.client.audience
fc6fd328-d6f6-4549-8bb1-3f8ea250373b	true	id.token.claim
fc6fd328-d6f6-4549-8bb1-3f8ea250373b	true	access.token.claim
fc6fd328-d6f6-4549-8bb1-3f8ea250373b	true	userinfo.token.claim
83b21a94-8eb3-4540-a45a-0a99b5113dec	true	multivalued
83b21a94-8eb3-4540-a45a-0a99b5113dec	true	userinfo.token.claim
83b21a94-8eb3-4540-a45a-0a99b5113dec	foo	user.attribute
83b21a94-8eb3-4540-a45a-0a99b5113dec	true	id.token.claim
83b21a94-8eb3-4540-a45a-0a99b5113dec	true	access.token.claim
83b21a94-8eb3-4540-a45a-0a99b5113dec	groups	claim.name
83b21a94-8eb3-4540-a45a-0a99b5113dec	String	jsonType.label
3ec0e55a-8a9a-45a7-93cc-878874ea7a44	true	userinfo.token.claim
3ec0e55a-8a9a-45a7-93cc-878874ea7a44	zoneinfo	user.attribute
3ec0e55a-8a9a-45a7-93cc-878874ea7a44	true	id.token.claim
3ec0e55a-8a9a-45a7-93cc-878874ea7a44	true	access.token.claim
3ec0e55a-8a9a-45a7-93cc-878874ea7a44	zoneinfo	claim.name
3ec0e55a-8a9a-45a7-93cc-878874ea7a44	String	jsonType.label
550d2a62-5210-4ab8-a198-afc6bed52866	true	userinfo.token.claim
550d2a62-5210-4ab8-a198-afc6bed52866	birthdate	user.attribute
550d2a62-5210-4ab8-a198-afc6bed52866	true	id.token.claim
550d2a62-5210-4ab8-a198-afc6bed52866	true	access.token.claim
550d2a62-5210-4ab8-a198-afc6bed52866	birthdate	claim.name
550d2a62-5210-4ab8-a198-afc6bed52866	String	jsonType.label
6aed1ed2-19f2-4927-8130-cf749e107dcf	true	id.token.claim
6aed1ed2-19f2-4927-8130-cf749e107dcf	true	access.token.claim
6aed1ed2-19f2-4927-8130-cf749e107dcf	true	userinfo.token.claim
72962421-b1f3-418e-a363-752fe8e1a53a	true	userinfo.token.claim
72962421-b1f3-418e-a363-752fe8e1a53a	middleName	user.attribute
72962421-b1f3-418e-a363-752fe8e1a53a	true	id.token.claim
72962421-b1f3-418e-a363-752fe8e1a53a	true	access.token.claim
72962421-b1f3-418e-a363-752fe8e1a53a	middle_name	claim.name
72962421-b1f3-418e-a363-752fe8e1a53a	String	jsonType.label
85e2ab4c-b02c-42cc-9953-b882c83508a9	true	userinfo.token.claim
85e2ab4c-b02c-42cc-9953-b882c83508a9	locale	user.attribute
85e2ab4c-b02c-42cc-9953-b882c83508a9	true	id.token.claim
85e2ab4c-b02c-42cc-9953-b882c83508a9	true	access.token.claim
85e2ab4c-b02c-42cc-9953-b882c83508a9	locale	claim.name
85e2ab4c-b02c-42cc-9953-b882c83508a9	String	jsonType.label
8a2ca18a-5f7e-461d-be4a-8a6fb4af5648	true	userinfo.token.claim
8a2ca18a-5f7e-461d-be4a-8a6fb4af5648	profile	user.attribute
8a2ca18a-5f7e-461d-be4a-8a6fb4af5648	true	id.token.claim
8a2ca18a-5f7e-461d-be4a-8a6fb4af5648	true	access.token.claim
8a2ca18a-5f7e-461d-be4a-8a6fb4af5648	profile	claim.name
8a2ca18a-5f7e-461d-be4a-8a6fb4af5648	String	jsonType.label
90af5992-e42e-446e-a878-63df540c49b2	true	userinfo.token.claim
90af5992-e42e-446e-a878-63df540c49b2	username	user.attribute
90af5992-e42e-446e-a878-63df540c49b2	true	id.token.claim
90af5992-e42e-446e-a878-63df540c49b2	true	access.token.claim
90af5992-e42e-446e-a878-63df540c49b2	preferred_username	claim.name
90af5992-e42e-446e-a878-63df540c49b2	String	jsonType.label
94e43432-ed88-40e6-8c95-a216d7877733	true	userinfo.token.claim
94e43432-ed88-40e6-8c95-a216d7877733	picture	user.attribute
94e43432-ed88-40e6-8c95-a216d7877733	true	id.token.claim
94e43432-ed88-40e6-8c95-a216d7877733	true	access.token.claim
94e43432-ed88-40e6-8c95-a216d7877733	picture	claim.name
94e43432-ed88-40e6-8c95-a216d7877733	String	jsonType.label
b56d46db-6948-4cd5-ad06-90e9922ce90d	true	userinfo.token.claim
b56d46db-6948-4cd5-ad06-90e9922ce90d	nickname	user.attribute
b56d46db-6948-4cd5-ad06-90e9922ce90d	true	id.token.claim
b56d46db-6948-4cd5-ad06-90e9922ce90d	true	access.token.claim
b56d46db-6948-4cd5-ad06-90e9922ce90d	nickname	claim.name
b56d46db-6948-4cd5-ad06-90e9922ce90d	String	jsonType.label
b6f47d77-e670-4358-8788-2c36e4714802	true	userinfo.token.claim
b6f47d77-e670-4358-8788-2c36e4714802	website	user.attribute
b6f47d77-e670-4358-8788-2c36e4714802	true	id.token.claim
b6f47d77-e670-4358-8788-2c36e4714802	true	access.token.claim
b6f47d77-e670-4358-8788-2c36e4714802	website	claim.name
b6f47d77-e670-4358-8788-2c36e4714802	String	jsonType.label
ca789e92-b182-49b1-9bb5-3865a9594216	true	userinfo.token.claim
ca789e92-b182-49b1-9bb5-3865a9594216	firstName	user.attribute
ca789e92-b182-49b1-9bb5-3865a9594216	true	id.token.claim
ca789e92-b182-49b1-9bb5-3865a9594216	true	access.token.claim
ca789e92-b182-49b1-9bb5-3865a9594216	given_name	claim.name
ca789e92-b182-49b1-9bb5-3865a9594216	String	jsonType.label
d7352bf5-9d78-4a4a-83c8-6cd1a7f08f03	true	userinfo.token.claim
d7352bf5-9d78-4a4a-83c8-6cd1a7f08f03	lastName	user.attribute
d7352bf5-9d78-4a4a-83c8-6cd1a7f08f03	true	id.token.claim
d7352bf5-9d78-4a4a-83c8-6cd1a7f08f03	true	access.token.claim
d7352bf5-9d78-4a4a-83c8-6cd1a7f08f03	family_name	claim.name
d7352bf5-9d78-4a4a-83c8-6cd1a7f08f03	String	jsonType.label
e15bfa9b-544c-4cac-a850-41b4f8ca7b41	true	userinfo.token.claim
e15bfa9b-544c-4cac-a850-41b4f8ca7b41	updatedAt	user.attribute
e15bfa9b-544c-4cac-a850-41b4f8ca7b41	true	id.token.claim
e15bfa9b-544c-4cac-a850-41b4f8ca7b41	true	access.token.claim
e15bfa9b-544c-4cac-a850-41b4f8ca7b41	updated_at	claim.name
e15bfa9b-544c-4cac-a850-41b4f8ca7b41	String	jsonType.label
f8be96e6-5079-4276-b2e2-865d01ad0957	true	userinfo.token.claim
f8be96e6-5079-4276-b2e2-865d01ad0957	gender	user.attribute
f8be96e6-5079-4276-b2e2-865d01ad0957	true	id.token.claim
f8be96e6-5079-4276-b2e2-865d01ad0957	true	access.token.claim
f8be96e6-5079-4276-b2e2-865d01ad0957	gender	claim.name
f8be96e6-5079-4276-b2e2-865d01ad0957	String	jsonType.label
ba25df63-647d-4b53-9ea8-f1b5b17ab051	true	userinfo.token.claim
ba25df63-647d-4b53-9ea8-f1b5b17ab051	emailVerified	user.attribute
ba25df63-647d-4b53-9ea8-f1b5b17ab051	true	id.token.claim
ba25df63-647d-4b53-9ea8-f1b5b17ab051	true	access.token.claim
ba25df63-647d-4b53-9ea8-f1b5b17ab051	email_verified	claim.name
ba25df63-647d-4b53-9ea8-f1b5b17ab051	boolean	jsonType.label
ecbaafe9-11b5-4b56-a4ac-53b5476f056d	true	userinfo.token.claim
ecbaafe9-11b5-4b56-a4ac-53b5476f056d	email	user.attribute
ecbaafe9-11b5-4b56-a4ac-53b5476f056d	true	id.token.claim
ecbaafe9-11b5-4b56-a4ac-53b5476f056d	true	access.token.claim
ecbaafe9-11b5-4b56-a4ac-53b5476f056d	email	claim.name
ecbaafe9-11b5-4b56-a4ac-53b5476f056d	String	jsonType.label
3aeda11a-6139-4cdc-984f-82f68618469e	formatted	user.attribute.formatted
3aeda11a-6139-4cdc-984f-82f68618469e	country	user.attribute.country
3aeda11a-6139-4cdc-984f-82f68618469e	postal_code	user.attribute.postal_code
3aeda11a-6139-4cdc-984f-82f68618469e	true	userinfo.token.claim
3aeda11a-6139-4cdc-984f-82f68618469e	street	user.attribute.street
3aeda11a-6139-4cdc-984f-82f68618469e	true	id.token.claim
3aeda11a-6139-4cdc-984f-82f68618469e	region	user.attribute.region
3aeda11a-6139-4cdc-984f-82f68618469e	true	access.token.claim
3aeda11a-6139-4cdc-984f-82f68618469e	locality	user.attribute.locality
3b65dbfa-5d45-4551-a4d5-0e70e00f3b31	true	userinfo.token.claim
3b65dbfa-5d45-4551-a4d5-0e70e00f3b31	phoneNumber	user.attribute
3b65dbfa-5d45-4551-a4d5-0e70e00f3b31	true	id.token.claim
3b65dbfa-5d45-4551-a4d5-0e70e00f3b31	true	access.token.claim
3b65dbfa-5d45-4551-a4d5-0e70e00f3b31	phone_number	claim.name
3b65dbfa-5d45-4551-a4d5-0e70e00f3b31	String	jsonType.label
b7fc80f6-4ba7-4408-af5d-06ed76dd65ee	true	userinfo.token.claim
b7fc80f6-4ba7-4408-af5d-06ed76dd65ee	phoneNumberVerified	user.attribute
b7fc80f6-4ba7-4408-af5d-06ed76dd65ee	true	id.token.claim
b7fc80f6-4ba7-4408-af5d-06ed76dd65ee	true	access.token.claim
b7fc80f6-4ba7-4408-af5d-06ed76dd65ee	phone_number_verified	claim.name
b7fc80f6-4ba7-4408-af5d-06ed76dd65ee	boolean	jsonType.label
215bd997-5575-4180-a4fc-3bca00239f85	foo	user.attribute
215bd997-5575-4180-a4fc-3bca00239f85	true	access.token.claim
215bd997-5575-4180-a4fc-3bca00239f85	resource_access.${client_id}.roles	claim.name
215bd997-5575-4180-a4fc-3bca00239f85	String	jsonType.label
215bd997-5575-4180-a4fc-3bca00239f85	true	multivalued
80d7aba7-6151-4485-99a3-a41ef3766767	foo	user.attribute
80d7aba7-6151-4485-99a3-a41ef3766767	true	access.token.claim
80d7aba7-6151-4485-99a3-a41ef3766767	realm_access.roles	claim.name
80d7aba7-6151-4485-99a3-a41ef3766767	String	jsonType.label
80d7aba7-6151-4485-99a3-a41ef3766767	true	multivalued
942ca4ef-01e2-497d-8ce3-2cca357f35eb	true	userinfo.token.claim
942ca4ef-01e2-497d-8ce3-2cca357f35eb	username	user.attribute
942ca4ef-01e2-497d-8ce3-2cca357f35eb	true	id.token.claim
942ca4ef-01e2-497d-8ce3-2cca357f35eb	true	access.token.claim
942ca4ef-01e2-497d-8ce3-2cca357f35eb	upn	claim.name
942ca4ef-01e2-497d-8ce3-2cca357f35eb	String	jsonType.label
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	true	multivalued
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	true	userinfo.token.claim
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	foo	user.attribute
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	true	id.token.claim
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	true	access.token.claim
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	groups	claim.name
c1b0d4ad-7d0a-43e0-89b0-4975f3d626a6	String	jsonType.label
3abd8ade-e674-4364-8e87-c9f490c300dc	false	full.path
3abd8ade-e674-4364-8e87-c9f490c300dc	true	id.token.claim
3abd8ade-e674-4364-8e87-c9f490c300dc	true	access.token.claim
3abd8ade-e674-4364-8e87-c9f490c300dc	user_group	claim.name
3abd8ade-e674-4364-8e87-c9f490c300dc	true	userinfo.token.claim
315f78da-9a8a-4f92-934c-e6de44246b80	clientId	user.session.note
315f78da-9a8a-4f92-934c-e6de44246b80	true	userinfo.token.claim
315f78da-9a8a-4f92-934c-e6de44246b80	true	id.token.claim
315f78da-9a8a-4f92-934c-e6de44246b80	true	access.token.claim
315f78da-9a8a-4f92-934c-e6de44246b80	clientId	claim.name
315f78da-9a8a-4f92-934c-e6de44246b80	String	jsonType.label
6f7f2746-4ebf-4641-b614-f44cc62b4a30	clientAddress	user.session.note
6f7f2746-4ebf-4641-b614-f44cc62b4a30	true	userinfo.token.claim
6f7f2746-4ebf-4641-b614-f44cc62b4a30	true	id.token.claim
6f7f2746-4ebf-4641-b614-f44cc62b4a30	true	access.token.claim
6f7f2746-4ebf-4641-b614-f44cc62b4a30	clientAddress	claim.name
6f7f2746-4ebf-4641-b614-f44cc62b4a30	String	jsonType.label
e11617c6-5131-424a-8e7b-3292ce925d5a	true	multivalued
e11617c6-5131-424a-8e7b-3292ce925d5a	true	userinfo.token.claim
e11617c6-5131-424a-8e7b-3292ce925d5a	foo	user.attribute
e11617c6-5131-424a-8e7b-3292ce925d5a	true	id.token.claim
e11617c6-5131-424a-8e7b-3292ce925d5a	true	access.token.claim
e11617c6-5131-424a-8e7b-3292ce925d5a	organization	claim.name
e11617c6-5131-424a-8e7b-3292ce925d5a	String	jsonType.label
f4053176-3f37-4dcb-b99a-eaa6c7cc576f	clientHost	user.session.note
f4053176-3f37-4dcb-b99a-eaa6c7cc576f	true	userinfo.token.claim
f4053176-3f37-4dcb-b99a-eaa6c7cc576f	true	id.token.claim
f4053176-3f37-4dcb-b99a-eaa6c7cc576f	true	access.token.claim
f4053176-3f37-4dcb-b99a-eaa6c7cc576f	clientHost	claim.name
f4053176-3f37-4dcb-b99a-eaa6c7cc576f	String	jsonType.label
00dd46a7-162c-4daf-b41f-2717d44b56a3	clientId	user.session.note
00dd46a7-162c-4daf-b41f-2717d44b56a3	true	userinfo.token.claim
00dd46a7-162c-4daf-b41f-2717d44b56a3	true	id.token.claim
00dd46a7-162c-4daf-b41f-2717d44b56a3	true	access.token.claim
00dd46a7-162c-4daf-b41f-2717d44b56a3	clientId	claim.name
00dd46a7-162c-4daf-b41f-2717d44b56a3	String	jsonType.label
4df02771-4cab-4d3e-9d55-f6c0854405f3	true	userinfo.token.claim
4df02771-4cab-4d3e-9d55-f6c0854405f3	role	user.attribute
4df02771-4cab-4d3e-9d55-f6c0854405f3	true	id.token.claim
4df02771-4cab-4d3e-9d55-f6c0854405f3	true	access.token.claim
4df02771-4cab-4d3e-9d55-f6c0854405f3	role	claim.name
4df02771-4cab-4d3e-9d55-f6c0854405f3	String	jsonType.label
932a8954-57c7-4c3d-9240-10f6e3323c77	clientHost	user.session.note
932a8954-57c7-4c3d-9240-10f6e3323c77	true	userinfo.token.claim
932a8954-57c7-4c3d-9240-10f6e3323c77	true	id.token.claim
932a8954-57c7-4c3d-9240-10f6e3323c77	true	access.token.claim
932a8954-57c7-4c3d-9240-10f6e3323c77	clientHost	claim.name
932a8954-57c7-4c3d-9240-10f6e3323c77	String	jsonType.label
a26c720f-7075-49d3-bec7-447cd4555420	clientAddress	user.session.note
a26c720f-7075-49d3-bec7-447cd4555420	true	userinfo.token.claim
a26c720f-7075-49d3-bec7-447cd4555420	true	id.token.claim
a26c720f-7075-49d3-bec7-447cd4555420	true	access.token.claim
a26c720f-7075-49d3-bec7-447cd4555420	clientAddress	claim.name
a26c720f-7075-49d3-bec7-447cd4555420	String	jsonType.label
d3af927f-e850-447f-8816-8ad8f530e683	true	multivalued
d3af927f-e850-447f-8816-8ad8f530e683	true	userinfo.token.claim
d3af927f-e850-447f-8816-8ad8f530e683	foo	user.attribute
d3af927f-e850-447f-8816-8ad8f530e683	true	id.token.claim
d3af927f-e850-447f-8816-8ad8f530e683	true	access.token.claim
d3af927f-e850-447f-8816-8ad8f530e683	resource_access.${client_id}.roles	claim.name
d3af927f-e850-447f-8816-8ad8f530e683	String	jsonType.label
0947ecbf-b0ee-45d6-9ee7-a0c81c567186	clientId	user.session.note
0947ecbf-b0ee-45d6-9ee7-a0c81c567186	true	userinfo.token.claim
0947ecbf-b0ee-45d6-9ee7-a0c81c567186	true	id.token.claim
0947ecbf-b0ee-45d6-9ee7-a0c81c567186	true	access.token.claim
0947ecbf-b0ee-45d6-9ee7-a0c81c567186	clientId	claim.name
0947ecbf-b0ee-45d6-9ee7-a0c81c567186	String	jsonType.label
27914c0b-5ad2-44c6-a7c8-e2472269053f	clientHost	user.session.note
27914c0b-5ad2-44c6-a7c8-e2472269053f	true	userinfo.token.claim
27914c0b-5ad2-44c6-a7c8-e2472269053f	true	id.token.claim
27914c0b-5ad2-44c6-a7c8-e2472269053f	true	access.token.claim
27914c0b-5ad2-44c6-a7c8-e2472269053f	clientHost	claim.name
27914c0b-5ad2-44c6-a7c8-e2472269053f	String	jsonType.label
7dda5348-5d64-4e25-b41b-25ddd0b84121	clientAddress	user.session.note
7dda5348-5d64-4e25-b41b-25ddd0b84121	true	userinfo.token.claim
7dda5348-5d64-4e25-b41b-25ddd0b84121	true	id.token.claim
7dda5348-5d64-4e25-b41b-25ddd0b84121	true	access.token.claim
7dda5348-5d64-4e25-b41b-25ddd0b84121	clientAddress	claim.name
7dda5348-5d64-4e25-b41b-25ddd0b84121	String	jsonType.label
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	true	multivalued
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	true	userinfo.token.claim
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	true	id.token.claim
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	true	access.token.claim
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	grafana_role	claim.name
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	String	jsonType.label
f71c6ee2-a38d-4934-b7c3-96d582f01a9b	essim-dashboard	usermodel.clientRoleMapping.clientId
421d4f07-c4fa-4e07-ac3d-a6e1a442ab80	true	userinfo.token.claim
421d4f07-c4fa-4e07-ac3d-a6e1a442ab80	locale	user.attribute
421d4f07-c4fa-4e07-ac3d-a6e1a442ab80	true	id.token.claim
421d4f07-c4fa-4e07-ac3d-a6e1a442ab80	true	access.token.claim
421d4f07-c4fa-4e07-ac3d-a6e1a442ab80	locale	claim.name
421d4f07-c4fa-4e07-ac3d-a6e1a442ab80	String	jsonType.label
3a5028b8-fec4-44c6-bce5-4bce39af2ba6	true	id.token.claim
3a5028b8-fec4-44c6-bce5-4bce39af2ba6	true	access.token.claim
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
esdl-mapeditor	60	300	300	keycloak	keycloak	keycloak	t	t	0	keycloak	esdl-mapeditor	1594220296	\N	f	f	t	f	EXTERNAL	1800	36000	f	f	f331d10d-6ca4-4105-9e57-7d0cc0aaf7f5	1800	f	en	f	t	f	f	0	1	30	6	HmacSHA1	totp	1a3494ea-2fa2-4db2-8e5e-f098b0b5a745	2cbfcaff-1611-4885-8690-f66301590060	7777b461-9a33-4cf6-8e3b-9f40ef295774	76239c04-5887-4a49-994d-cd4e09c48e9b	cee5f852-edd8-4e5d-9201-7b360518bab3	2592000	f	900	t	f	f30a023f-6317-4b62-9c8c-6e6e5c88558d	0	t	0	0	d1510da4-d458-4d2a-9cc6-ae62d900ed7e
27484249-b2b6-4f42-81db-28866ec26a77	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	d8c1eb85-609a-4124-a680-2004c04d18a8	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	6500200e-21ff-45c6-ab01-d459b2026079	224d7007-9a31-4bed-8e46-23463deb7f7d	5dec0a8e-c880-4cf0-8a9f-5e3745f23241	bcff79eb-6901-4676-a2ab-0a5c9dbc7daf	db6fdc30-6f9b-4003-a3db-4aee1c02639b	2592000	f	900	t	f	8672d4fe-6f4a-4f7d-b596-ff37f3ab1b14	0	f	0	0	de8d7a77-af60-4af7-8dc0-a01d2aaf6c48
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	27484249-b2b6-4f42-81db-28866ec26a77	
_browser_header.xContentTypeOptions	27484249-b2b6-4f42-81db-28866ec26a77	nosniff
_browser_header.xRobotsTag	27484249-b2b6-4f42-81db-28866ec26a77	none
_browser_header.xFrameOptions	27484249-b2b6-4f42-81db-28866ec26a77	SAMEORIGIN
_browser_header.contentSecurityPolicy	27484249-b2b6-4f42-81db-28866ec26a77	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	27484249-b2b6-4f42-81db-28866ec26a77	1; mode=block
_browser_header.strictTransportSecurity	27484249-b2b6-4f42-81db-28866ec26a77	max-age=31536000; includeSubDomains
bruteForceProtected	27484249-b2b6-4f42-81db-28866ec26a77	false
permanentLockout	27484249-b2b6-4f42-81db-28866ec26a77	false
maxFailureWaitSeconds	27484249-b2b6-4f42-81db-28866ec26a77	900
minimumQuickLoginWaitSeconds	27484249-b2b6-4f42-81db-28866ec26a77	60
waitIncrementSeconds	27484249-b2b6-4f42-81db-28866ec26a77	60
quickLoginCheckMilliSeconds	27484249-b2b6-4f42-81db-28866ec26a77	1000
maxDeltaTimeSeconds	27484249-b2b6-4f42-81db-28866ec26a77	43200
failureFactor	27484249-b2b6-4f42-81db-28866ec26a77	30
realmReusableOtpCode	27484249-b2b6-4f42-81db-28866ec26a77	false
displayName	27484249-b2b6-4f42-81db-28866ec26a77	Keycloak
displayNameHtml	27484249-b2b6-4f42-81db-28866ec26a77	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	27484249-b2b6-4f42-81db-28866ec26a77	RS256
offlineSessionMaxLifespanEnabled	27484249-b2b6-4f42-81db-28866ec26a77	false
offlineSessionMaxLifespan	27484249-b2b6-4f42-81db-28866ec26a77	5184000
_browser_header.contentSecurityPolicyReportOnly	esdl-mapeditor	
_browser_header.xContentTypeOptions	esdl-mapeditor	nosniff
_browser_header.xRobotsTag	esdl-mapeditor	none
_browser_header.xFrameOptions	esdl-mapeditor	SAMEORIGIN
_browser_header.contentSecurityPolicy	esdl-mapeditor	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	esdl-mapeditor	1; mode=block
_browser_header.strictTransportSecurity	esdl-mapeditor	max-age=31536000; includeSubDomains
bruteForceProtected	esdl-mapeditor	false
permanentLockout	esdl-mapeditor	false
maxFailureWaitSeconds	esdl-mapeditor	900
minimumQuickLoginWaitSeconds	esdl-mapeditor	60
waitIncrementSeconds	esdl-mapeditor	60
quickLoginCheckMilliSeconds	esdl-mapeditor	1000
maxDeltaTimeSeconds	esdl-mapeditor	43200
failureFactor	esdl-mapeditor	30
realmReusableOtpCode	esdl-mapeditor	false
displayName	esdl-mapeditor	ESDL Studio
defaultSignatureAlgorithm	esdl-mapeditor	RS256
offlineSessionMaxLifespanEnabled	esdl-mapeditor	false
offlineSessionMaxLifespan	esdl-mapeditor	5184000
clientSessionIdleTimeout	esdl-mapeditor	0
clientSessionMaxLifespan	esdl-mapeditor	0
clientOfflineSessionIdleTimeout	esdl-mapeditor	0
clientOfflineSessionMaxLifespan	esdl-mapeditor	0
actionTokenGeneratedByAdminLifespan	esdl-mapeditor	43200
actionTokenGeneratedByUserLifespan	esdl-mapeditor	300
oauth2DeviceCodeLifespan	esdl-mapeditor	600
oauth2DevicePollingInterval	esdl-mapeditor	5
webAuthnPolicyRpEntityName	esdl-mapeditor	keycloak
webAuthnPolicySignatureAlgorithms	esdl-mapeditor	ES256
webAuthnPolicyRpId	esdl-mapeditor	
webAuthnPolicyAttestationConveyancePreference	esdl-mapeditor	not specified
webAuthnPolicyAuthenticatorAttachment	esdl-mapeditor	not specified
webAuthnPolicyRequireResidentKey	esdl-mapeditor	not specified
webAuthnPolicyUserVerificationRequirement	esdl-mapeditor	not specified
webAuthnPolicyCreateTimeout	esdl-mapeditor	0
webAuthnPolicyAvoidSameAuthenticatorRegister	esdl-mapeditor	false
webAuthnPolicyRpEntityNamePasswordless	esdl-mapeditor	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	esdl-mapeditor	ES256
webAuthnPolicyRpIdPasswordless	esdl-mapeditor	
webAuthnPolicyAttestationConveyancePreferencePasswordless	esdl-mapeditor	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	esdl-mapeditor	not specified
webAuthnPolicyRequireResidentKeyPasswordless	esdl-mapeditor	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	esdl-mapeditor	not specified
webAuthnPolicyCreateTimeoutPasswordless	esdl-mapeditor	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	esdl-mapeditor	false
cibaBackchannelTokenDeliveryMode	esdl-mapeditor	poll
cibaExpiresIn	esdl-mapeditor	120
cibaInterval	esdl-mapeditor	5
cibaAuthRequestedUserHint	esdl-mapeditor	login_hint
parRequestUriLifespan	esdl-mapeditor	60
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
esdl-mapeditor	482140fe-404e-413e-b80b-cab5ff75d6d3
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
esdl-mapeditor	SEND_RESET_PASSWORD
esdl-mapeditor	UPDATE_TOTP
esdl-mapeditor	REMOVE_TOTP
esdl-mapeditor	REVOKE_GRANT
esdl-mapeditor	LOGIN_ERROR
esdl-mapeditor	CLIENT_LOGIN
esdl-mapeditor	RESET_PASSWORD_ERROR
esdl-mapeditor	IMPERSONATE_ERROR
esdl-mapeditor	CODE_TO_TOKEN_ERROR
esdl-mapeditor	CUSTOM_REQUIRED_ACTION
esdl-mapeditor	RESTART_AUTHENTICATION
esdl-mapeditor	UPDATE_PROFILE_ERROR
esdl-mapeditor	IMPERSONATE
esdl-mapeditor	LOGIN
esdl-mapeditor	UPDATE_PASSWORD_ERROR
esdl-mapeditor	CLIENT_INITIATED_ACCOUNT_LINKING
esdl-mapeditor	TOKEN_EXCHANGE
esdl-mapeditor	REGISTER
esdl-mapeditor	LOGOUT
esdl-mapeditor	CLIENT_REGISTER
esdl-mapeditor	IDENTITY_PROVIDER_LINK_ACCOUNT
esdl-mapeditor	UPDATE_PASSWORD
esdl-mapeditor	FEDERATED_IDENTITY_LINK_ERROR
esdl-mapeditor	CLIENT_DELETE
esdl-mapeditor	IDENTITY_PROVIDER_FIRST_LOGIN
esdl-mapeditor	VERIFY_EMAIL
esdl-mapeditor	CLIENT_DELETE_ERROR
esdl-mapeditor	CLIENT_LOGIN_ERROR
esdl-mapeditor	RESTART_AUTHENTICATION_ERROR
esdl-mapeditor	REMOVE_FEDERATED_IDENTITY_ERROR
esdl-mapeditor	EXECUTE_ACTIONS
esdl-mapeditor	TOKEN_EXCHANGE_ERROR
esdl-mapeditor	PERMISSION_TOKEN
esdl-mapeditor	SEND_IDENTITY_PROVIDER_LINK_ERROR
esdl-mapeditor	EXECUTE_ACTION_TOKEN_ERROR
esdl-mapeditor	SEND_VERIFY_EMAIL
esdl-mapeditor	EXECUTE_ACTIONS_ERROR
esdl-mapeditor	REMOVE_FEDERATED_IDENTITY
esdl-mapeditor	IDENTITY_PROVIDER_POST_LOGIN
esdl-mapeditor	IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR
esdl-mapeditor	UPDATE_EMAIL
esdl-mapeditor	REGISTER_ERROR
esdl-mapeditor	REVOKE_GRANT_ERROR
esdl-mapeditor	LOGOUT_ERROR
esdl-mapeditor	UPDATE_EMAIL_ERROR
esdl-mapeditor	EXECUTE_ACTION_TOKEN
esdl-mapeditor	CLIENT_UPDATE_ERROR
esdl-mapeditor	UPDATE_PROFILE
esdl-mapeditor	FEDERATED_IDENTITY_LINK
esdl-mapeditor	CLIENT_REGISTER_ERROR
esdl-mapeditor	SEND_VERIFY_EMAIL_ERROR
esdl-mapeditor	SEND_IDENTITY_PROVIDER_LINK
esdl-mapeditor	RESET_PASSWORD
esdl-mapeditor	CLIENT_INITIATED_ACCOUNT_LINKING_ERROR
esdl-mapeditor	REMOVE_TOTP_ERROR
esdl-mapeditor	VERIFY_EMAIL_ERROR
esdl-mapeditor	SEND_RESET_PASSWORD_ERROR
esdl-mapeditor	CLIENT_UPDATE
esdl-mapeditor	IDENTITY_PROVIDER_POST_LOGIN_ERROR
esdl-mapeditor	CUSTOM_REQUIRED_ACTION_ERROR
esdl-mapeditor	UPDATE_TOTP_ERROR
esdl-mapeditor	CODE_TO_TOKEN
esdl-mapeditor	IDENTITY_PROVIDER_FIRST_LOGIN_ERROR
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
27484249-b2b6-4f42-81db-28866ec26a77	jboss-logging
esdl-mapeditor	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	27484249-b2b6-4f42-81db-28866ec26a77
password	password	t	t	esdl-mapeditor
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
esdl-mapeditor	de
esdl-mapeditor	no
esdl-mapeditor	ru
esdl-mapeditor	sv
esdl-mapeditor	pt-BR
esdl-mapeditor	lt
esdl-mapeditor	en
esdl-mapeditor	it
esdl-mapeditor	fr
esdl-mapeditor	zh-CN
esdl-mapeditor	es
esdl-mapeditor	ja
esdl-mapeditor	sk
esdl-mapeditor	pl
esdl-mapeditor	ca
esdl-mapeditor	nl
esdl-mapeditor	tr
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.redirect_uris (client_id, value) FROM stdin;
9e6a4f15-daf9-4df9-ae71-566bd8d1e2ab	/realms/master/account/*
3685fc1f-d0a1-488f-b4b6-6085c430766a	/realms/master/account/*
98188f0b-9771-4045-a9d2-36e13ad07ec6	/admin/master/console/*
043f3b1d-595d-4fe1-b984-7fc13582cdf2	/realms/esdl-mapeditor/account/*
295b1d84-f59f-4336-b864-6fb3cf140de1	/realms/esdl-mapeditor/account/*
c335a38b-9f6c-4256-bc10-43561bb80698	http://localhost:9080/*
c335a38b-9f6c-4256-bc10-43561bb80698	https://localhost:9443/*
4d2874c8-1177-4cd4-991f-9a62ce88db03	http://localhost:8111/*
603d98fb-fd82-446a-aec4-03abc7a0ebd4	http://localhost:3000/*
ee1eff39-a727-46a3-9d18-0600e356d847	/admin/esdl-mapeditor/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
ba1e4340-ec76-43de-a917-6a095e733796	VERIFY_EMAIL	Verify Email	27484249-b2b6-4f42-81db-28866ec26a77	t	f	VERIFY_EMAIL	50
f8b6e701-c0e3-4c49-b355-8b882589fa0c	UPDATE_PROFILE	Update Profile	27484249-b2b6-4f42-81db-28866ec26a77	t	f	UPDATE_PROFILE	40
66811b09-2f16-462c-b8b4-ff68eded7f46	CONFIGURE_TOTP	Configure OTP	27484249-b2b6-4f42-81db-28866ec26a77	t	f	CONFIGURE_TOTP	10
db778489-d782-4859-baea-0a8dda85274a	UPDATE_PASSWORD	Update Password	27484249-b2b6-4f42-81db-28866ec26a77	t	f	UPDATE_PASSWORD	30
9c6df361-cf15-437d-afaa-60d59b922425	terms_and_conditions	Terms and Conditions	27484249-b2b6-4f42-81db-28866ec26a77	f	f	terms_and_conditions	20
824c1eea-d415-4549-bffb-8feecd5c0e75	delete_account	Delete Account	27484249-b2b6-4f42-81db-28866ec26a77	f	f	delete_account	60
bfcf5ab2-2e15-43af-bce8-8389199d5ae7	update_user_locale	Update User Locale	27484249-b2b6-4f42-81db-28866ec26a77	t	f	update_user_locale	1000
2b9872dd-0db6-4270-a90b-94eaf73a55ff	webauthn-register	Webauthn Register	27484249-b2b6-4f42-81db-28866ec26a77	t	f	webauthn-register	70
dd3e99da-1bac-472c-9e2f-9a3a9ddd9e23	webauthn-register-passwordless	Webauthn Register Passwordless	27484249-b2b6-4f42-81db-28866ec26a77	t	f	webauthn-register-passwordless	80
f99d7cf3-d2d1-4378-b09f-65b7cd92ed3f	CONFIGURE_TOTP	Configure OTP	esdl-mapeditor	t	f	CONFIGURE_TOTP	10
8324c456-7c54-43d5-b6f8-0ba0211b4777	terms_and_conditions	Terms and Conditions	esdl-mapeditor	f	f	terms_and_conditions	20
0cb47711-d93f-4ba0-997a-92949862d098	UPDATE_PASSWORD	Update Password	esdl-mapeditor	t	f	UPDATE_PASSWORD	30
9d254d31-04d6-4e2c-b8e3-9297255227b4	UPDATE_PROFILE	Update Profile	esdl-mapeditor	t	f	UPDATE_PROFILE	40
0c9d9a83-430c-4fe7-9bbd-abb953b56e1f	VERIFY_EMAIL	Verify Email	esdl-mapeditor	t	f	VERIFY_EMAIL	50
c9d6a308-05dc-4c22-a4c6-4ec32bdee49a	update_user_locale	Update User Locale	esdl-mapeditor	t	f	update_user_locale	1000
9bf2bbd9-16d3-4037-be15-3b1d5b37370b	delete_account	Delete Account	esdl-mapeditor	f	f	delete_account	60
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
4d2874c8-1177-4cd4-991f-9a62ce88db03	t	0	1
603d98fb-fd82-446a-aec4-03abc7a0ebd4	t	0	1
c335a38b-9f6c-4256-bc10-43561bb80698	t	0	1
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
3685fc1f-d0a1-488f-b4b6-6085c430766a	e539f317-c351-427b-94ee-a73428a6076a
3685fc1f-d0a1-488f-b4b6-6085c430766a	1e7dd160-cdfe-4dff-a4af-d9284466ee09
295b1d84-f59f-4336-b864-6fb3cf140de1	a1f7eb1d-8611-4529-9710-c85994fafaaf
295b1d84-f59f-4336-b864-6fb3cf140de1	e835f1ba-29eb-4c8f-87fd-619625a48e1c
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
66c445f6-57d8-4caa-b577-0c50df4932da	\N	39cf7e9c-05df-4da4-af09-29902447bd17	f	t	\N	\N	\N	27484249-b2b6-4f42-81db-28866ec26a77	admin	1750280703452	\N	0
0a899b0a-e1ba-4fc5-80ee-3d20a1b8ba98	\N	3c349287-4ba5-4e58-b854-1693b8d264f3	f	t	\N	\N	\N	esdl-mapeditor	service-account-cdo-mondaine	1594211075651	c335a38b-9f6c-4256-bc10-43561bb80698	0
e4767aa6-00a1-48c7-aaf8-d1ba4182bc47	\N	d94971a1-5540-42b7-92f3-790ecb6683a0	f	t	\N	\N	\N	esdl-mapeditor	service-account-esdl-mapeditor	1594213647877	4d2874c8-1177-4cd4-991f-9a62ce88db03	0
755f3f68-43c3-4d77-bb97-ff4874f9e17c	\N	d75d9122-cd0c-4e57-9a89-a251b9ff8b45	f	t	\N	\N	\N	esdl-mapeditor	service-account-essim-dashboard	1594211853467	603d98fb-fd82-446a-aec4-03abc7a0ebd4	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
de8d7a77-af60-4af7-8dc0-a01d2aaf6c48	66c445f6-57d8-4caa-b577-0c50df4932da
0911a89f-8275-4bb6-960b-4252db55883e	66c445f6-57d8-4caa-b577-0c50df4932da
0ad83d6d-c9f0-4241-9da8-fe8a02a2e6bf	0a899b0a-e1ba-4fc5-80ee-3d20a1b8ba98
b1427348-28b2-42be-8fc4-6016e39387ae	0a899b0a-e1ba-4fc5-80ee-3d20a1b8ba98
1ca04ae7-fe60-41e9-9b86-1d53afbbd037	0a899b0a-e1ba-4fc5-80ee-3d20a1b8ba98
d4eb6018-6682-4096-9f8a-e02c142beb96	0a899b0a-e1ba-4fc5-80ee-3d20a1b8ba98
a1f7eb1d-8611-4529-9710-c85994fafaaf	0a899b0a-e1ba-4fc5-80ee-3d20a1b8ba98
0ad83d6d-c9f0-4241-9da8-fe8a02a2e6bf	e4767aa6-00a1-48c7-aaf8-d1ba4182bc47
b1427348-28b2-42be-8fc4-6016e39387ae	e4767aa6-00a1-48c7-aaf8-d1ba4182bc47
b39c9570-2628-4d8d-ab48-b71bdcce1a1a	e4767aa6-00a1-48c7-aaf8-d1ba4182bc47
d4eb6018-6682-4096-9f8a-e02c142beb96	e4767aa6-00a1-48c7-aaf8-d1ba4182bc47
a1f7eb1d-8611-4529-9710-c85994fafaaf	e4767aa6-00a1-48c7-aaf8-d1ba4182bc47
0ad83d6d-c9f0-4241-9da8-fe8a02a2e6bf	755f3f68-43c3-4d77-bb97-ff4874f9e17c
b1427348-28b2-42be-8fc4-6016e39387ae	755f3f68-43c3-4d77-bb97-ff4874f9e17c
d4eb6018-6682-4096-9f8a-e02c142beb96	755f3f68-43c3-4d77-bb97-ff4874f9e17c
a1f7eb1d-8611-4529-9710-c85994fafaaf	755f3f68-43c3-4d77-bb97-ff4874f9e17c
4cd94d4c-d544-4b5a-9d70-d009766387a3	755f3f68-43c3-4d77-bb97-ff4874f9e17c
7ee203c8-9329-4374-976c-5fd01282ae96	66c445f6-57d8-4caa-b577-0c50df4932da
e9624eb4-f121-491d-a9c3-e519d09394bd	66c445f6-57d8-4caa-b577-0c50df4932da
e26270fb-4930-4ced-b234-1135a1b8f608	66c445f6-57d8-4caa-b577-0c50df4932da
ab058e32-17fb-4a4c-b740-341ef4694ad2	66c445f6-57d8-4caa-b577-0c50df4932da
3aa484e8-a49a-4425-865e-74c26c69d092	66c445f6-57d8-4caa-b577-0c50df4932da
ca23f832-91c4-4c05-84ba-0bcecfb1b0ab	66c445f6-57d8-4caa-b577-0c50df4932da
8b7d1b7a-7bf3-4b39-a025-472e793f9386	66c445f6-57d8-4caa-b577-0c50df4932da
db89105d-f183-4a0c-938c-0e2628a34e31	66c445f6-57d8-4caa-b577-0c50df4932da
f038ba1b-9e36-4d8f-a1d5-658364e83110	66c445f6-57d8-4caa-b577-0c50df4932da
e5981d58-57b4-425a-844f-97383e91628c	66c445f6-57d8-4caa-b577-0c50df4932da
1aca210a-d49f-416d-b8c7-09cc055e11c8	66c445f6-57d8-4caa-b577-0c50df4932da
8be0e294-6fdd-4bd0-a89a-df5b1de4a3ce	66c445f6-57d8-4caa-b577-0c50df4932da
ca08d7a2-dfac-4137-96cc-1f4d6ac72d23	66c445f6-57d8-4caa-b577-0c50df4932da
c7ee3e24-315a-485e-a7ba-6e0258b62073	66c445f6-57d8-4caa-b577-0c50df4932da
7a49202f-aa76-4ace-91e2-1ac9602e97cf	66c445f6-57d8-4caa-b577-0c50df4932da
a311004f-4ed6-4e77-9f87-78a7bbfc6083	66c445f6-57d8-4caa-b577-0c50df4932da
4cdfa079-3de3-40a8-bf49-b6d982620bfc	66c445f6-57d8-4caa-b577-0c50df4932da
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.web_origins (client_id, value) FROM stdin;
98188f0b-9771-4045-a9d2-36e13ad07ec6	+
c335a38b-9f6c-4256-bc10-43561bb80698	+
4d2874c8-1177-4cd4-991f-9a62ce88db03	
603d98fb-fd82-446a-aec4-03abc7a0ebd4	http://localhost:3000
ee1eff39-a727-46a3-9d18-0600e356d847	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

