--
-- PostgreSQL database dump
--

\restrict 72IOhpm30jeKShptTYhbx0I3ZZFBq96tyzQDLDBb7cgnVCKqM6dwdgbgc3o7hwh

-- Dumped from database version 14.19 (Ubuntu 14.19-1.pgdg22.04+1)
-- Dumped by pg_dump version 17.6 (Ubuntu 17.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: medusa
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO medusa;

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: medusa
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO medusa;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: medusa
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO medusa;

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: medusa
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO medusa;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO medusa;

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO medusa;

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO medusa;

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO medusa;

--
-- Name: approval; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.approval (
    id text NOT NULL,
    cart_id text NOT NULL,
    type text NOT NULL,
    status text NOT NULL,
    created_by text NOT NULL,
    handled_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT approval_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))),
    CONSTRAINT approval_type_check CHECK ((type = ANY (ARRAY['admin'::text, 'sales_manager'::text])))
);


ALTER TABLE public.approval OWNER TO medusa;

--
-- Name: approval_settings; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.approval_settings (
    id text NOT NULL,
    requires_admin_approval boolean DEFAULT false NOT NULL,
    requires_sales_manager_approval boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    company_id text NOT NULL
);


ALTER TABLE public.approval_settings OWNER TO medusa;

--
-- Name: approval_status; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.approval_status (
    id text NOT NULL,
    cart_id text NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT approval_status_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])))
);


ALTER TABLE public.approval_status OWNER TO medusa;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO medusa;

--
-- Name: capture; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO medusa;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO medusa;

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO medusa;

--
-- Name: cart_cart_approval_approval; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_cart_approval_approval (
    cart_id character varying(255) NOT NULL,
    approval_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_cart_approval_approval OWNER TO medusa;

--
-- Name: cart_cart_approval_approval_status; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_cart_approval_approval_status (
    cart_id character varying(255) NOT NULL,
    approval_status_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_cart_approval_approval_status OWNER TO medusa;

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO medusa;

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO medusa;

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO medusa;

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO medusa;

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO medusa;

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO medusa;

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO medusa;

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO medusa;

--
-- Name: company; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.company (
    id text NOT NULL,
    name text NOT NULL,
    phone text,
    email text NOT NULL,
    address text,
    city text,
    state text,
    zip text,
    country text,
    logo_url text,
    currency_code text,
    spending_limit_reset_frequency text DEFAULT 'monthly'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT company_spending_limit_reset_frequency_check CHECK ((spending_limit_reset_frequency = ANY (ARRAY['never'::text, 'daily'::text, 'weekly'::text, 'monthly'::text, 'yearly'::text])))
);


ALTER TABLE public.company OWNER TO medusa;

--
-- Name: company_company_approval_approval_settings; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.company_company_approval_approval_settings (
    company_id character varying(255) NOT NULL,
    approval_settings_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.company_company_approval_approval_settings OWNER TO medusa;

--
-- Name: company_company_cart_cart; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.company_company_cart_cart (
    company_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.company_company_cart_cart OWNER TO medusa;

--
-- Name: company_company_customer_customer_group; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.company_company_customer_customer_group (
    company_id character varying(255) NOT NULL,
    customer_group_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.company_company_customer_customer_group OWNER TO medusa;

--
-- Name: company_employee_customer_customer; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.company_employee_customer_customer (
    employee_id character varying(255) NOT NULL,
    customer_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.company_employee_customer_customer OWNER TO medusa;

--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO medusa;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO medusa;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO medusa;

--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO medusa;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO medusa;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO medusa;

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO medusa;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.employee (
    id text NOT NULL,
    spending_limit numeric DEFAULT 0 NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    company_id text NOT NULL,
    raw_spending_limit jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.employee OWNER TO medusa;

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO medusa;

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO medusa;

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO medusa;

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO medusa;

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO medusa;

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO medusa;

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO medusa;

--
-- Name: image; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO medusa;

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO medusa;

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO medusa;

--
-- Name: invite; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO medusa;

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO medusa;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO medusa;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO medusa;

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO medusa;

--
-- Name: message; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.message (
    id text NOT NULL,
    text text NOT NULL,
    item_id text,
    admin_id text,
    customer_id text,
    quote_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.message OWNER TO medusa;

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO medusa;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO medusa;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO medusa;

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO medusa;

--
-- Name: order; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO medusa;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO medusa;

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO medusa;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO medusa;

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO medusa;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO medusa;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO medusa;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO medusa;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO medusa;

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO medusa;

--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_credit_line OWNER TO medusa;

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO medusa;

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO medusa;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO medusa;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO medusa;

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO medusa;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO medusa;

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO medusa;

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_adjustment OWNER TO medusa;

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO medusa;

--
-- Name: order_order_company_company; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_order_company_company (
    order_id character varying(255) NOT NULL,
    company_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_order_company_company OWNER TO medusa;

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO medusa;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO medusa;

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO medusa;

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO medusa;

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO medusa;

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO medusa;

--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO medusa;

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO medusa;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO medusa;

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO medusa;

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO medusa;

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO medusa;

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO medusa;

--
-- Name: price; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


ALTER TABLE public.price OWNER TO medusa;

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO medusa;

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO medusa;

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO medusa;

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO medusa;

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO medusa;

--
-- Name: product; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO medusa;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO medusa;

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO medusa;

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO medusa;

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO medusa;

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO medusa;

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO medusa;

--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO medusa;

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO medusa;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO medusa;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO medusa;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO medusa;

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO medusa;

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO medusa;

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO medusa;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO medusa;

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO medusa;

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO medusa;

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO medusa;

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO medusa;

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO medusa;

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO medusa;

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO medusa;

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO medusa;

--
-- Name: quote; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.quote (
    id text NOT NULL,
    status text DEFAULT 'pending_merchant'::text NOT NULL,
    customer_id text NOT NULL,
    draft_order_id text NOT NULL,
    order_change_id text NOT NULL,
    cart_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT quote_status_check CHECK ((status = ANY (ARRAY['pending_merchant'::text, 'pending_customer'::text, 'accepted'::text, 'customer_rejected'::text, 'merchant_rejected'::text])))
);


ALTER TABLE public.quote OWNER TO medusa;

--
-- Name: refund; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO medusa;

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.refund_reason OWNER TO medusa;

--
-- Name: region; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO medusa;

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO medusa;

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO medusa;

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO medusa;

--
-- Name: return; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO medusa;

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO medusa;

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO medusa;

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO medusa;

--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO medusa;

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO medusa;

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO medusa;

--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO medusa;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.script_migrations_id_seq OWNER TO medusa;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO medusa;

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO medusa;

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO medusa;

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO medusa;

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO medusa;

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO medusa;

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO medusa;

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO medusa;

--
-- Name: store; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO medusa;

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO medusa;

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO medusa;

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO medusa;

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO medusa;

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO medusa;

--
-- Name: user; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO medusa;

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: medusa
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01K4SMAAHBPCCBEJ428B3ZPY0E'::text NOT NULL
);


ALTER TABLE public.workflow_execution OWNER TO medusa;

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01K4SMAFA87MNM0CHNZW64P5S1	pk_b6990fcb6532e49ca176d701bcf73e0ef33c0384f5a3de15c5ddd4e9376a4794		pk_b69***794	Webshop	publishable	\N		2025-09-10 12:56:39.752+02	\N	\N	2025-09-10 12:56:39.752+02	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: approval; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.approval (id, cart_id, type, status, created_by, handled_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: approval_settings; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.approval_settings (id, requires_admin_approval, requires_sales_manager_approval, created_at, updated_at, deleted_at, company_id) FROM stdin;
\.


--
-- Data for Name: approval_status; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.approval_status (id, cart_id, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01K4SMAHPFVWVBPFZ8HTBDT6VP	{"user_id": "user_01K4SMAHM26RJ5B6M2BJR13N3T"}	2025-09-10 12:56:42.191+02	2025-09-10 12:56:42.199+02	\N
authid_01K4TK99H514S99H5VF47NHSA4	{"customer_id": "cus_01K4TK99J1MVJ5NH0SFTQ9EWA2"}	2025-09-10 21:57:46.917+02	2025-09-10 21:57:46.957+02	\N
authid_01K5YBMGMZ5N167SX9Y8AW93B2	{"user_id": "user_01K5YBMGJXCB1ZENM46NH9HP8C"}	2025-09-24 19:16:45.599+02	2025-09-24 19:16:45.609+02	\N
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
cart_01K4SVNZST3AC2ZXWG0DY4BQHD	reg_01K4SMAF6Q56P0DB7GRM9TBN94	cus_01K4TK99J1MVJ5NH0SFTQ9EWA2	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	nagy.viktordp@gmail.com	eur	\N	caaddr_01K4TJW8WF01NJ3WVWTRF4JSY6	{}	2025-09-10 15:05:17.115+02	2025-09-10 21:57:47.055+02	\N	\N
cart_01K5YB7NR9PBEEDFR6NH3H6HRE	reg_01K4SMAF6Q56P0DB7GRM9TBN94	\N	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	\N	eur	\N	\N	{}	2025-09-24 19:09:44.841+02	2025-09-24 19:09:44.841+02	\N	\N
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
caaddr_01K4SWMFVEWFPT35QGBTRX6B7D	\N		Nagy	Viktor	Hlavna 9	\N	Kolarovo	sk	Nitra	94603	+421915785377	\N	2025-09-10 15:21:56.591+02	2025-09-10 15:21:56.591+02	\N
caaddr_01K4SWYKEH1750444D90KAM6N4	\N		Nagy	Viktor	Hlavna 9	\N	Kolarovo	sk	Nitra	94603	+421915785377	\N	2025-09-10 15:27:27.953+02	2025-09-10 15:27:27.953+02	\N
caaddr_01K4TJW8WF01NJ3WVWTRF4JSY6	\N		Nagy	Viktor	Hlavna 9	\N	Kolarovo	sk	Nitra	94603	+421915785377	\N	2025-09-10 21:50:40.272+02	2025-09-10 21:50:40.272+02	\N
\.


--
-- Data for Name: cart_cart_approval_approval; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_cart_approval_approval (cart_id, approval_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_cart_approval_approval_status; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_cart_approval_approval_status (cart_id, approval_status_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
cali_01K4SVNZYKJ3P5YQ425VXXA5MA	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	34" QD-OLED Curved Gaming Monitor | Ultra-Wide | Infinite Contrast | 175Hz	ACME Monitor 4k White	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-front.png	1	variant_01K4SMAFG746NFPNQWJ4MZRBJ5	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	34" QD-OLED Curved Gaming Monitor | Ultra-Wide | Infinite Contrast | 175Hz	Experience the pinnacle of display technology with this 34-inch curved monitor. By merging OLED panels and Quantum Dot technology, this QD-OLED screen delivers exceptional contrast, deep blacks, unlimited viewing angles, and vivid colors. The curved design provides an immersive experience, allowing you to enjoy the best of both worlds in one cutting-edge display. This innovative monitor represents the ultimate fusion of visual performance and immersive design.	\N	\N	Featured	34-qd-oled-curved-gaming-monitor-ultra-wide-infinite-contrast-175hz	ACME-MONITOR-BLACK	\N	ACME Monitor 4k White	\N	f	t	f	\N	\N	599	{"value": "599", "precision": 20}	{}	2025-09-10 15:05:17.268+02	2025-09-10 15:16:00.244+02	\N	\N	f	f
cali_01K4SWVHR5T9PDMCFKSFVQ51XS	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	Conference Speaker | High-Performance | Budget-Friendly	Speaker White	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	1	variant_01K4SMAFN4T2MAH09C3Q3B9Y6N	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	Conference Speaker | High-Performance | Budget-Friendly	This compact, powerful conference speaker offers exceptional, high-performance features at a surprisingly affordable price. Packed with advanced productivity-enhancing technology, it delivers premium functionality without the premium price tag. Experience better meetings and improved communication, regardless of where your team members are calling from.	\N	\N	\N	conference-speaker-high-performance-budget-friendly	SPEAKER-WHITE	\N	Speaker White	\N	f	t	f	\N	\N	55	{"value": "55", "precision": 20}	{}	2025-09-10 15:25:47.909+02	2025-09-10 15:25:47.909+02	\N	\N	f	f
cali_01K4SWVHR5KSYFZYAEVHT0HA48	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	Conference Speaker | High-Performance | Budget-Friendly	Speaker Black	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	2	variant_01K4SMAFN434CQDX67W374CZ8Y	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	Conference Speaker | High-Performance | Budget-Friendly	This compact, powerful conference speaker offers exceptional, high-performance features at a surprisingly affordable price. Packed with advanced productivity-enhancing technology, it delivers premium functionality without the premium price tag. Experience better meetings and improved communication, regardless of where your team members are calling from.	\N	\N	\N	conference-speaker-high-performance-budget-friendly	SPEAKER-BLACK	\N	Speaker Black	\N	f	t	f	\N	\N	79	{"value": "79", "precision": 20}	{}	2025-09-10 15:25:47.909+02	2025-09-10 22:00:13.194+02	\N	\N	f	f
cali_01K4TJTKCVQTHQKGS702NW70W8	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	256 GB / Blue	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	1	variant_01K4SMAFC1GHM2N13S4DN6QTE7	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	\N	\N	Featured	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	256-BLUE	\N	256 GB / Blue	\N	f	t	f	\N	\N	1299	{"value": "1299", "precision": 20}	{}	2025-09-10 21:49:45.499+02	2025-09-10 21:49:45.499+02	\N	\N	f	f
cali_01K4TJTKCVWCP7XA6YF6A8V59P	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	512 GB / Red	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	1	variant_01K4SMAFC1Y8ZVF41HRH3DY0VG	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	\N	\N	Featured	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	512-RED	\N	512 GB / Red	\N	f	t	f	\N	\N	1259	{"value": "1259", "precision": 20}	{}	2025-09-10 21:49:45.499+02	2025-09-10 21:49:45.499+02	\N	\N	f	f
cali_01K4SXVN312D9NC09Q5T3EJM28	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	6.5" Ultra HD Smartphone | 3x Impact-Resistant Screen	256 GB Purple	https://medusa-public-images.s3.eu-west-1.amazonaws.com/phone-front.png	2	variant_01K4SMAFEW2X2NBC9T3EMFEXYJ	prod_01K4SMAFEDYWQRAJDZBMNPDXWF	6.5" Ultra HD Smartphone | 3x Impact-Resistant Screen	This premium smartphone is crafted from durable and lightweight aerospace-grade aluminum, featuring an expansive 6.5" Ultra-High Definition AMOLED display. It boasts exceptional durability with a cutting-edge nanocrystal glass front, offering three times the impact resistance of standard smartphone screens. The device combines sleek design with robust protection, setting a new standard for smartphone resilience and visual excellence. Copy	\N	\N	Featured	65-ultra-hd-smartphone-3x-impact-resistant-screen	PHONE-256-PURPLE	\N	256 GB Purple	\N	f	t	f	\N	\N	999	{"value": "999", "precision": 20}	{}	2025-09-10 15:43:19.905+02	2025-09-10 21:53:11.823+02	2025-09-10 21:53:11.822+02	\N	f	f
cali_01K5YB7NYJZ4C5F2X4H8YX7J17	cart_01K5YB7NR9PBEEDFR6NH3H6HRE	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	256 GB / Blue	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	1	variant_01K4SMAFC1GHM2N13S4DN6QTE7	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	\N	\N	Featured	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	256-BLUE	\N	256 GB / Blue	\N	f	t	f	\N	\N	1299	{"value": "1299", "precision": 20}	{}	2025-09-24 19:09:45.042+02	2025-09-24 19:09:45.042+02	\N	\N	f	f
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.company (id, name, phone, email, address, city, state, zip, country, logo_url, currency_code, spending_limit_reset_frequency, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: company_company_approval_approval_settings; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.company_company_approval_approval_settings (company_id, approval_settings_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: company_company_cart_cart; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.company_company_cart_cart (company_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: company_company_customer_customer_group; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.company_company_customer_customer_group (company_id, customer_group_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: company_employee_customer_customer; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.company_employee_customer_customer (employee_id, customer_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-09-10 12:56:37.002+02	2025-09-10 12:56:37.002+02	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-09-10 12:56:37.003+02	2025-09-10 12:56:37.003+02	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
cus_01K4TK99J1MVJ5NH0SFTQ9EWA2		Nagy	Viktor	nagy.viktordp@gmail.com		t	\N	2025-09-10 21:57:46.945+02	2025-09-10 21:57:46.945+02	\N	\N
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.employee (id, spending_limit, is_admin, company_id, raw_spending_limit, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-09-10 12:56:37.107+02	2025-09-10 12:56:37.107+02	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01K4SMAF860FQFEE83DH7AT2GQ	European Warehouse delivery	shipping	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
fuset_01K5YBXX90BNG8BXBN5SXQ5H3S	Kolárovo Teherguminet pick up	pickup	\N	2025-09-24 19:21:53.441+02	2025-09-24 19:21:53.441+02	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01K4SMAF856X42G5PSQ0FM7SB2	country	gb	\N	\N	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	\N	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
fgz_01K4SMAF855VFJNM2B3G7TB2WB	country	de	\N	\N	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	\N	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
fgz_01K4SMAF8547T02S839SR3EJYF	country	dk	\N	\N	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	\N	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
fgz_01K4SMAF85915YF22G0CXMCSMZ	country	se	\N	\N	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	\N	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
fgz_01K4SMAF86MYBBFGN58PKAWPPN	country	fr	\N	\N	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	\N	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
fgz_01K4SMAF860CGK6YSA17E0DQHK	country	es	\N	\N	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	\N	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
fgz_01K4SMAF86G4GNNRKNE8ZCEK33	country	it	\N	\N	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	\N	\N	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01K4SMAFB9HJ933THGB45S9AG8	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N	0	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5
img_01K4SMAFB9BZQP968T0MSM18FS	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-side.png	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N	1	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5
img_01K4SMAFB94ZJQD9JTQVWPM8V1	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-top.png	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N	2	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5
img_01K4SMAFD30XR8SFPTYDV4QXNM	https://medusa-public-images.s3.eu-west-1.amazonaws.com/camera-front.png	\N	2025-09-10 12:56:39.844+02	2025-09-10 12:56:39.844+02	\N	0	prod_01K4SMAFD3474PBAS6AH4WA2TD
img_01K4SMAFD4DQQ7E4WRGK2CY6K6	https://medusa-public-images.s3.eu-west-1.amazonaws.com/camera-side.png	\N	2025-09-10 12:56:39.844+02	2025-09-10 12:56:39.844+02	\N	1	prod_01K4SMAFD3474PBAS6AH4WA2TD
img_01K4SMAFEDQKEMD1XK4YV4DK9Z	https://medusa-public-images.s3.eu-west-1.amazonaws.com/phone-front.png	\N	2025-09-10 12:56:39.886+02	2025-09-10 12:56:39.886+02	\N	0	prod_01K4SMAFEDYWQRAJDZBMNPDXWF
img_01K4SMAFED5BPPV9KM4RT99DST	https://medusa-public-images.s3.eu-west-1.amazonaws.com/phone-side.png	\N	2025-09-10 12:56:39.886+02	2025-09-10 12:56:39.886+02	\N	1	prod_01K4SMAFEDYWQRAJDZBMNPDXWF
img_01K4SMAFEDGJD09ZC1P9FNWRGD	https://medusa-public-images.s3.eu-west-1.amazonaws.com/phone-bottom.png	\N	2025-09-10 12:56:39.886+02	2025-09-10 12:56:39.886+02	\N	2	prod_01K4SMAFEDYWQRAJDZBMNPDXWF
img_01K4SMAFFRVNXR5N5QA681VGTR	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-front.png	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N	0	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP
img_01K4SMAFFRYVKJZDCK30YZ4JT5	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-side.png	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N	1	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP
img_01K4SMAFFRES5NYYA45Y821MBC	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-top.png	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N	2	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP
img_01K4SMAFFR7HP7MHQ5EY5NAMSB	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-back.png	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N	3	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP
img_01K4SMAFH0QFSX62R0WCXJAD00	https://medusa-public-images.s3.eu-west-1.amazonaws.com/headphone-front.png	\N	2025-09-10 12:56:39.968+02	2025-09-10 12:56:39.968+02	\N	0	prod_01K4SMAFH0PXTG0BQ4R3FZFMGF
img_01K4SMAFH0SATBFDVHR6PTPZAT	https://medusa-public-images.s3.eu-west-1.amazonaws.com/headphone-side.png	\N	2025-09-10 12:56:39.968+02	2025-09-10 12:56:39.968+02	\N	1	prod_01K4SMAFH0PXTG0BQ4R3FZFMGF
img_01K4SMAFH04W9Z9ZRYEE2YCQF6	https://medusa-public-images.s3.eu-west-1.amazonaws.com/headphone-top.png	\N	2025-09-10 12:56:39.968+02	2025-09-10 12:56:39.968+02	\N	2	prod_01K4SMAFH0PXTG0BQ4R3FZFMGF
img_01K4SMAFJ8AAAZMC69BR7NV8Y8	https://medusa-public-images.s3.eu-west-1.amazonaws.com/keyboard-front.png	\N	2025-09-10 12:56:40.009+02	2025-09-10 12:56:40.009+02	\N	0	prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX
img_01K4SMAFJ8BF61MJW4F7NVYDTG	https://medusa-public-images.s3.eu-west-1.amazonaws.com/keyboard-side.png	\N	2025-09-10 12:56:40.009+02	2025-09-10 12:56:40.009+02	\N	1	prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX
img_01K4SMAFKF8K2GCECH0261BC3C	https://medusa-public-images.s3.eu-west-1.amazonaws.com/mouse-top.png	\N	2025-09-10 12:56:40.048+02	2025-09-10 12:56:40.048+02	\N	0	prod_01K4SMAFKF8Z91Z9BH77TATWP0
img_01K4SMAFKF2WQ3AKZ2VSD8YGCN	https://medusa-public-images.s3.eu-west-1.amazonaws.com/mouse-front.png	\N	2025-09-10 12:56:40.048+02	2025-09-10 12:56:40.048+02	\N	1	prod_01K4SMAFKF8Z91Z9BH77TATWP0
img_01K4SMAFMNKYPH8X9AGCWTFB4C	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	\N	2025-09-10 12:56:40.086+02	2025-09-10 12:56:40.086+02	\N	0	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC
img_01K4SMAFMPA2XHPBA79M8N9RJ0	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-front.png	\N	2025-09-10 12:56:40.086+02	2025-09-10 12:56:40.086+02	\N	1	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-09-10 12:56:35.613718
2	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-09-10 12:56:35.618184
3	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-09-10 12:56:35.618467
4	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-09-10 12:56:35.618595
5	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-09-10 12:56:35.618673
6	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-09-10 12:56:35.61886
7	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-09-10 12:56:35.618864
8	order_promotion	{"toModel": "promotion", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-09-10 12:56:35.619091
9	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-09-10 12:56:35.619386
10	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-09-10 12:56:35.620192
11	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-09-10 12:56:35.728401
12	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-09-10 12:56:35.736695
13	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-09-10 12:56:35.745413
14	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-09-10 12:56:35.745484
15	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-09-10 12:56:35.74554
17	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-09-10 12:56:35.745601
16	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-09-10 12:56:35.745581
18	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-09-10 12:56:35.745684
19	cart_cart_approval_approval_status	{"toModel": "approval_status", "toModule": "approval", "fromModel": "cart", "fromModule": "cart"}	2025-09-10 12:56:35.745682
20	cart_cart_approval_approval	{"toModel": "approval", "toModule": "approval", "fromModel": "cart", "fromModule": "cart"}	2025-09-10 12:56:35.745722
21	company_company_approval_approval_settings	{"toModel": "approval_settings", "toModule": "approval", "fromModel": "company", "fromModule": "company"}	2025-09-10 12:56:35.853872
22	company_company_cart_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "company", "fromModule": "company"}	2025-09-10 12:56:35.86007
23	company_company_customer_customer_group	{"toModel": "customer_group", "toModule": "customer", "fromModel": "company", "fromModule": "company"}	2025-09-10 12:56:35.870344
24	company_employee_customer_customer	{"toModel": "customer", "toModule": "customer", "fromModel": "employee", "fromModule": "company"}	2025-09-10 12:56:35.874907
25	order_order_company_company	{"toModel": "company", "toModule": "company", "fromModel": "order", "fromModule": "order"}	2025-09-10 12:56:35.875096
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K4SMAF7MT4EDYRTNSRREKBR7	manual_manual	locfp_01K4SMAF7T33P4ZQ56BENJTPMX	2025-09-10 12:56:39.674152+02	2025-09-10 12:56:39.674152+02	\N
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K4SMAF7MT4EDYRTNSRREKBR7	fuset_01K4SMAF860FQFEE83DH7AT2GQ	locfs_01K4SMAF8EY87DDBTWM5NWKZ0W	2025-09-10 12:56:39.694772+02	2025-09-10 12:56:39.694772+02	\N
sloc_01K4SMAF7MT4EDYRTNSRREKBR7	fuset_01K5YBXX90BNG8BXBN5SXQ5H3S	locfs_01K5YBXX9GWXQ6ZR7TEDVEBNKE	2025-09-24 19:21:53.456152+02	2025-09-24 19:21:53.456152+02	\N
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.message (id, text, item_id, admin_id, customer_id, quote_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-09-10 12:56:14.928709+02
2	Migration20241210073813	2025-09-10 12:56:14.928709+02
3	Migration20250106142624	2025-09-10 12:56:14.928709+02
4	Migration20250120110820	2025-09-10 12:56:14.928709+02
5	Migration20240307132720	2025-09-10 12:56:15.065076+02
6	Migration20240719123015	2025-09-10 12:56:15.065076+02
7	Migration20241213063611	2025-09-10 12:56:15.065076+02
8	InitialSetup20240401153642	2025-09-10 12:56:15.525799+02
9	Migration20240601111544	2025-09-10 12:56:15.525799+02
10	Migration202408271511	2025-09-10 12:56:15.525799+02
11	Migration20241122120331	2025-09-10 12:56:15.525799+02
12	Migration20241125090957	2025-09-10 12:56:15.525799+02
13	Migration20250411073236	2025-09-10 12:56:15.525799+02
14	Migration20250516081326	2025-09-10 12:56:15.525799+02
15	Migration20230929122253	2025-09-10 12:56:16.527967+02
16	Migration20240322094407	2025-09-10 12:56:16.527967+02
17	Migration20240322113359	2025-09-10 12:56:16.527967+02
18	Migration20240322120125	2025-09-10 12:56:16.527967+02
19	Migration20240626133555	2025-09-10 12:56:16.527967+02
20	Migration20240704094505	2025-09-10 12:56:16.527967+02
21	Migration20241127114534	2025-09-10 12:56:16.527967+02
22	Migration20241127223829	2025-09-10 12:56:16.527967+02
23	Migration20241128055359	2025-09-10 12:56:16.527967+02
24	Migration20241212190401	2025-09-10 12:56:16.527967+02
25	Migration20250408145122	2025-09-10 12:56:16.527967+02
26	Migration20250409122219	2025-09-10 12:56:16.527967+02
27	Migration20240227120221	2025-09-10 12:56:17.237541+02
28	Migration20240617102917	2025-09-10 12:56:17.237541+02
29	Migration20240624153824	2025-09-10 12:56:17.237541+02
30	Migration20241211061114	2025-09-10 12:56:17.237541+02
31	Migration20250113094144	2025-09-10 12:56:17.237541+02
32	Migration20250120110700	2025-09-10 12:56:17.237541+02
33	Migration20250226130616	2025-09-10 12:56:17.237541+02
34	Migration20240124154000	2025-09-10 12:56:17.947564+02
35	Migration20240524123112	2025-09-10 12:56:17.947564+02
36	Migration20240602110946	2025-09-10 12:56:17.947564+02
37	Migration20241211074630	2025-09-10 12:56:17.947564+02
38	Migration20240115152146	2025-09-10 12:56:18.174447+02
39	Migration20240222170223	2025-09-10 12:56:18.226542+02
40	Migration20240831125857	2025-09-10 12:56:18.226542+02
41	Migration20241106085918	2025-09-10 12:56:18.226542+02
42	Migration20241205095237	2025-09-10 12:56:18.226542+02
43	Migration20241216183049	2025-09-10 12:56:18.226542+02
44	Migration20241218091938	2025-09-10 12:56:18.226542+02
45	Migration20250120115059	2025-09-10 12:56:18.226542+02
46	Migration20250212131240	2025-09-10 12:56:18.226542+02
47	Migration20250326151602	2025-09-10 12:56:18.226542+02
48	Migration20240205173216	2025-09-10 12:56:18.893224+02
49	Migration20240624200006	2025-09-10 12:56:18.893224+02
50	Migration20250120110744	2025-09-10 12:56:18.893224+02
51	InitialSetup20240221144943	2025-09-10 12:56:18.997353+02
52	Migration20240604080145	2025-09-10 12:56:18.997353+02
53	Migration20241205122700	2025-09-10 12:56:18.997353+02
54	InitialSetup20240227075933	2025-09-10 12:56:19.07096+02
55	Migration20240621145944	2025-09-10 12:56:19.07096+02
56	Migration20241206083313	2025-09-10 12:56:19.07096+02
57	Migration20240227090331	2025-09-10 12:56:19.161303+02
58	Migration20240710135844	2025-09-10 12:56:19.161303+02
59	Migration20240924114005	2025-09-10 12:56:19.161303+02
60	Migration20241212052837	2025-09-10 12:56:19.161303+02
61	InitialSetup20240228133303	2025-09-10 12:56:19.41329+02
62	Migration20240624082354	2025-09-10 12:56:19.41329+02
63	Migration20240225134525	2025-09-10 12:56:19.451826+02
64	Migration20240806072619	2025-09-10 12:56:19.451826+02
65	Migration20241211151053	2025-09-10 12:56:19.451826+02
66	Migration20250115160517	2025-09-10 12:56:19.451826+02
67	Migration20250120110552	2025-09-10 12:56:19.451826+02
68	Migration20250123122334	2025-09-10 12:56:19.451826+02
69	Migration20250206105639	2025-09-10 12:56:19.451826+02
70	Migration20250207132723	2025-09-10 12:56:19.451826+02
76	Migration20240219102530	2025-09-10 12:56:32.279758+02
77	Migration20240604100512	2025-09-10 12:56:32.279758+02
78	Migration20240715102100	2025-09-10 12:56:32.279758+02
79	Migration20240715174100	2025-09-10 12:56:32.279758+02
80	Migration20240716081800	2025-09-10 12:56:32.279758+02
81	Migration20240801085921	2025-09-10 12:56:32.279758+02
82	Migration20240821164505	2025-09-10 12:56:32.279758+02
83	Migration20240821170920	2025-09-10 12:56:32.279758+02
84	Migration20240827133639	2025-09-10 12:56:32.279758+02
85	Migration20240902195921	2025-09-10 12:56:32.279758+02
86	Migration20240913092514	2025-09-10 12:56:32.279758+02
87	Migration20240930122627	2025-09-10 12:56:32.279758+02
88	Migration20241014142943	2025-09-10 12:56:32.279758+02
89	Migration20241106085223	2025-09-10 12:56:32.279758+02
90	Migration20241129124827	2025-09-10 12:56:32.279758+02
91	Migration20241217162224	2025-09-10 12:56:32.279758+02
92	Migration20250326151554	2025-09-10 12:56:32.279758+02
93	Migration20250522181137	2025-09-10 12:56:32.279758+02
94	Migration20240205025928	2025-09-10 12:56:33.682715+02
95	Migration20240529080336	2025-09-10 12:56:33.682715+02
96	Migration20241202100304	2025-09-10 12:56:33.682715+02
97	Migration20240214033943	2025-09-10 12:56:33.821967+02
98	Migration20240703095850	2025-09-10 12:56:33.821967+02
99	Migration20241202103352	2025-09-10 12:56:33.821967+02
100	Migration20240311145700_InitialSetupMigration	2025-09-10 12:56:33.959234+02
101	Migration20240821170957	2025-09-10 12:56:33.959234+02
102	Migration20240917161003	2025-09-10 12:56:33.959234+02
103	Migration20241217110416	2025-09-10 12:56:33.959234+02
104	Migration20250113122235	2025-09-10 12:56:33.959234+02
105	Migration20250120115002	2025-09-10 12:56:33.959234+02
106	Migration20240509083918_InitialSetupMigration	2025-09-10 12:56:34.577955+02
107	Migration20240628075401	2025-09-10 12:56:34.577955+02
108	Migration20240830094712	2025-09-10 12:56:34.577955+02
109	Migration20250120110514	2025-09-10 12:56:34.577955+02
110	Migration20231228143900	2025-09-10 12:56:34.747335+02
111	Migration20241206101446	2025-09-10 12:56:34.747335+02
112	Migration20250128174331	2025-09-10 12:56:34.747335+02
113	Migration20250505092459	2025-09-10 12:56:34.747335+02
114	Migration20240930144912	2025-09-10 12:56:34.949012+02
115	Migration20241001085304	2025-09-10 12:56:34.949012+02
116	Migration20241014114520	2025-09-10 12:56:34.949012+02
117	Migration20250107125154	2025-09-10 12:56:34.949012+02
118	Migration20241010104109	2025-09-10 12:56:35.041853+02
119	Migration20250107125203	2025-09-10 12:56:35.041853+02
120	Migration20250107125144	2025-09-10 12:56:35.133572+02
121	Migration20250108113324	2025-09-10 12:56:35.133572+02
122	Migration20250113133737	2025-09-10 12:56:35.133572+02
123	Migration20250115144941	2025-09-10 12:56:35.133572+02
124	Migration20250130105122	2025-09-10 12:56:35.133572+02
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-09-10 12:56:37.125+02	2025-09-10 12:56:37.125+02	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
order_01K4TNV6RR9NEKVVH38ZS47TQR	reg_01K4SMAF6Q56P0DB7GRM9TBN94	1	cus_01K4TK99J1MVJ5NH0SFTQ9EWA2	1	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	draft	t	nagy.viktordp@gmail.com	eur	\N	ordaddr_01K4TNV6RP1RZQHDDKT92AVS52	\N	\N	2025-09-10 22:42:31.066+02	2025-09-10 22:42:31.066+02	\N	\N
order_01K4TNZQK4G5N4K2PQVY084BP1	reg_01K4SMAF6Q56P0DB7GRM9TBN94	2	cus_01K4TK99J1MVJ5NH0SFTQ9EWA2	1	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	draft	t	nagy.viktordp@gmail.com	eur	\N	ordaddr_01K4TNZQK4RPP55ZY2YQENRC8V	\N	\N	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	\N
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
ordaddr_01K4TNV6RP1RZQHDDKT92AVS52	\N		Nagy	Viktor	Hlavna 9	\N	Kolarovo	sk	Nitra	94603	+421915785377	\N	2025-09-10 21:50:40.272+02	2025-09-10 21:50:40.272+02	\N
ordaddr_01K4TNZQK4RPP55ZY2YQENRC8V	\N		Nagy	Viktor	Hlavna 9	\N	Kolarovo	sk	Nitra	94603	+421915785377	\N	2025-09-10 21:50:40.272+02	2025-09-10 21:50:40.272+02	\N
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordch_01K4TNV6TQPVE1P90184K4EJE9	order_01K4TNV6RR9NEKVVH38ZS47TQR	2		pending		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-09-10 22:42:31.127+02	2025-09-10 22:42:31.127+02	edit	\N	\N	\N	\N
ordch_01K4TNZQMMY40DP3G95YJGZFX3	order_01K4TNZQK4G5N4K2PQVY084BP1	2		pending		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-09-10 22:44:59.413+02	2025-09-10 22:44:59.413+02	edit	\N	\N	\N	\N
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
orditem_01K4TNV6RSGQF9YME2XKTVGKPZ	order_01K4TNV6RR9NEKVVH38ZS47TQR	1	ordli_01K4TNV6RRDWEV1TJM9BQ6NY2N	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:42:31.066+02	2025-09-10 22:42:31.066+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNV6RT3JGHFB8G9EKJK4QH	order_01K4TNV6RR9NEKVVH38ZS47TQR	1	ordli_01K4TNV6RS8XW4KYNA6V090GSF	2	{"value": "2", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:42:31.067+02	2025-09-10 22:42:31.067+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNV6RT29RTM7P93J9KVNQH	order_01K4TNV6RR9NEKVVH38ZS47TQR	1	ordli_01K4TNV6RS800A21GG9KMGFZJR	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:42:31.067+02	2025-09-10 22:42:31.067+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNV6RTSWT2SR3BESGMM6KG	order_01K4TNV6RR9NEKVVH38ZS47TQR	1	ordli_01K4TNV6RSME4NSVGWAPMWM9CM	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:42:31.067+02	2025-09-10 22:42:31.067+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNV6RT9SSSZRH7S4N4XJAB	order_01K4TNV6RR9NEKVVH38ZS47TQR	1	ordli_01K4TNV6RSEFADF2DZ64631SCN	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:42:31.067+02	2025-09-10 22:42:31.067+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNZQK51GPNJVXP5AJ3TFRR	order_01K4TNZQK4G5N4K2PQVY084BP1	1	ordli_01K4TNZQK5SEA1VM6CBK2SNDV0	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNZQK5QBPHYV5WANYQNNP0	order_01K4TNZQK4G5N4K2PQVY084BP1	1	ordli_01K4TNZQK5XESE6YA8M77E6D5N	2	{"value": "2", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNZQK6M734TESKK8JVR97M	order_01K4TNZQK4G5N4K2PQVY084BP1	1	ordli_01K4TNZQK5VSNWES9WRW1J47VC	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNZQK6V2PS04H95CP23T2G	order_01K4TNZQK4G5N4K2PQVY084BP1	1	ordli_01K4TNZQK56W0X4QRJR71KWVD5	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K4TNZQK6WJ9MADAPC19JT9SW	order_01K4TNZQK4G5N4K2PQVY084BP1	1	ordli_01K4TNZQK5MYXB58YXRSRMVDPP	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
ordli_01K4TNV6RRDWEV1TJM9BQ6NY2N	\N	34" QD-OLED Curved Gaming Monitor | Ultra-Wide | Infinite Contrast | 175Hz	ACME Monitor 4k White	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-front.png	variant_01K4SMAFG746NFPNQWJ4MZRBJ5	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	34" QD-OLED Curved Gaming Monitor | Ultra-Wide | Infinite Contrast | 175Hz	Experience the pinnacle of display technology with this 34-inch curved monitor. By merging OLED panels and Quantum Dot technology, this QD-OLED screen delivers exceptional contrast, deep blacks, unlimited viewing angles, and vivid colors. The curved design provides an immersive experience, allowing you to enjoy the best of both worlds in one cutting-edge display. This innovative monitor represents the ultimate fusion of visual performance and immersive design.	\N	\N	Featured	34-qd-oled-curved-gaming-monitor-ultra-wide-infinite-contrast-175hz	ACME-MONITOR-BLACK	\N	ACME Monitor 4k White	\N	f	t	f	\N	\N	599	{"value": "599", "precision": 20}	{}	2025-09-10 22:42:31.066+02	2025-09-10 22:42:31.066+02	\N	t	\N	f
ordli_01K4TNV6RS8XW4KYNA6V090GSF	\N	Conference Speaker | High-Performance | Budget-Friendly	Speaker Black	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	variant_01K4SMAFN434CQDX67W374CZ8Y	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	Conference Speaker | High-Performance | Budget-Friendly	This compact, powerful conference speaker offers exceptional, high-performance features at a surprisingly affordable price. Packed with advanced productivity-enhancing technology, it delivers premium functionality without the premium price tag. Experience better meetings and improved communication, regardless of where your team members are calling from.	\N	\N	\N	conference-speaker-high-performance-budget-friendly	SPEAKER-BLACK	\N	Speaker Black	\N	f	t	f	\N	\N	79	{"value": "79", "precision": 20}	{}	2025-09-10 22:42:31.066+02	2025-09-10 22:42:31.066+02	\N	t	\N	f
ordli_01K4TNV6RS800A21GG9KMGFZJR	\N	Conference Speaker | High-Performance | Budget-Friendly	Speaker White	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	variant_01K4SMAFN4T2MAH09C3Q3B9Y6N	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	Conference Speaker | High-Performance | Budget-Friendly	This compact, powerful conference speaker offers exceptional, high-performance features at a surprisingly affordable price. Packed with advanced productivity-enhancing technology, it delivers premium functionality without the premium price tag. Experience better meetings and improved communication, regardless of where your team members are calling from.	\N	\N	\N	conference-speaker-high-performance-budget-friendly	SPEAKER-WHITE	\N	Speaker White	\N	f	t	f	\N	\N	55	{"value": "55", "precision": 20}	{}	2025-09-10 22:42:31.066+02	2025-09-10 22:42:31.066+02	\N	t	\N	f
ordli_01K4TNV6RSME4NSVGWAPMWM9CM	\N	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	256 GB / Blue	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	variant_01K4SMAFC1GHM2N13S4DN6QTE7	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	\N	\N	Featured	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	256-BLUE	\N	256 GB / Blue	\N	f	t	f	\N	\N	1299	{"value": "1299", "precision": 20}	{}	2025-09-10 22:42:31.066+02	2025-09-10 22:42:31.066+02	\N	t	\N	f
ordli_01K4TNV6RSEFADF2DZ64631SCN	\N	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	512 GB / Red	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	variant_01K4SMAFC1Y8ZVF41HRH3DY0VG	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	\N	\N	Featured	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	512-RED	\N	512 GB / Red	\N	f	t	f	\N	\N	1259	{"value": "1259", "precision": 20}	{}	2025-09-10 22:42:31.066+02	2025-09-10 22:42:31.066+02	\N	t	\N	f
ordli_01K4TNZQK5SEA1VM6CBK2SNDV0	\N	34" QD-OLED Curved Gaming Monitor | Ultra-Wide | Infinite Contrast | 175Hz	ACME Monitor 4k White	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-front.png	variant_01K4SMAFG746NFPNQWJ4MZRBJ5	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	34" QD-OLED Curved Gaming Monitor | Ultra-Wide | Infinite Contrast | 175Hz	Experience the pinnacle of display technology with this 34-inch curved monitor. By merging OLED panels and Quantum Dot technology, this QD-OLED screen delivers exceptional contrast, deep blacks, unlimited viewing angles, and vivid colors. The curved design provides an immersive experience, allowing you to enjoy the best of both worlds in one cutting-edge display. This innovative monitor represents the ultimate fusion of visual performance and immersive design.	\N	\N	Featured	34-qd-oled-curved-gaming-monitor-ultra-wide-infinite-contrast-175hz	ACME-MONITOR-BLACK	\N	ACME Monitor 4k White	\N	f	t	f	\N	\N	599	{"value": "599", "precision": 20}	{}	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	t	\N	f
ordli_01K4TNZQK5XESE6YA8M77E6D5N	\N	Conference Speaker | High-Performance | Budget-Friendly	Speaker Black	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	variant_01K4SMAFN434CQDX67W374CZ8Y	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	Conference Speaker | High-Performance | Budget-Friendly	This compact, powerful conference speaker offers exceptional, high-performance features at a surprisingly affordable price. Packed with advanced productivity-enhancing technology, it delivers premium functionality without the premium price tag. Experience better meetings and improved communication, regardless of where your team members are calling from.	\N	\N	\N	conference-speaker-high-performance-budget-friendly	SPEAKER-BLACK	\N	Speaker Black	\N	f	t	f	\N	\N	79	{"value": "79", "precision": 20}	{}	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	t	\N	f
ordli_01K4TNZQK5VSNWES9WRW1J47VC	\N	Conference Speaker | High-Performance | Budget-Friendly	Speaker White	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	variant_01K4SMAFN4T2MAH09C3Q3B9Y6N	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	Conference Speaker | High-Performance | Budget-Friendly	This compact, powerful conference speaker offers exceptional, high-performance features at a surprisingly affordable price. Packed with advanced productivity-enhancing technology, it delivers premium functionality without the premium price tag. Experience better meetings and improved communication, regardless of where your team members are calling from.	\N	\N	\N	conference-speaker-high-performance-budget-friendly	SPEAKER-WHITE	\N	Speaker White	\N	f	t	f	\N	\N	55	{"value": "55", "precision": 20}	{}	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	t	\N	f
ordli_01K4TNZQK56W0X4QRJR71KWVD5	\N	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	256 GB / Blue	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	variant_01K4SMAFC1GHM2N13S4DN6QTE7	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	\N	\N	Featured	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	256-BLUE	\N	256 GB / Blue	\N	f	t	f	\N	\N	1299	{"value": "1299", "precision": 20}	{}	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	t	\N	f
ordli_01K4TNZQK5MYXB58YXRSRMVDPP	\N	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	512 GB / Red	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	variant_01K4SMAFC1Y8ZVF41HRH3DY0VG	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	\N	\N	Featured	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	512-RED	\N	512 GB / Red	\N	f	t	f	\N	\N	1259	{"value": "1259", "precision": 20}	{}	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N	t	\N	f
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_order_company_company; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_order_company_company (order_id, company_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
ordsum_01K4TNV6RQPW1AGTYD2PEQC16T	order_01K4TNV6RR9NEKVVH38ZS47TQR	1	{"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 3370, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 3370, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 3370, "original_order_total": 3370, "raw_accounting_total": {"value": "3370", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "3370", "precision": 20}, "raw_current_order_total": {"value": "3370", "precision": 20}, "raw_original_order_total": {"value": "3370", "precision": 20}}	2025-09-10 22:42:31.067+02	2025-09-10 22:42:31.067+02	\N
ordsum_01K4TNZQK4CY1YB499CAJGSPZB	order_01K4TNZQK4G5N4K2PQVY084BP1	1	{"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 3370, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 3370, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 3370, "original_order_total": 3370, "raw_accounting_total": {"value": "3370", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "3370", "precision": 20}, "raw_current_order_total": {"value": "3370", "precision": 20}, "raw_original_order_total": {"value": "3370", "precision": 20}}	2025-09-10 22:44:59.366+02	2025-09-10 22:44:59.366+02	\N
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-09-10 12:56:37.032+02	2025-09-10 12:56:37.032+02	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01K4SMAF9CBPJZEYZCHGHK85ZY	\N	pset_01K4SMAF9C5W7YGY7CT9371SEK	usd	{"value": "10", "precision": 20}	0	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	\N	10	\N	\N
price_01K4SMAF9C4MA5ERDCE84G0031	\N	pset_01K4SMAF9C5W7YGY7CT9371SEK	eur	{"value": "10", "precision": 20}	0	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	\N	10	\N	\N
price_01K4SMAF9CK5VNZE27SSMBZXYP	\N	pset_01K4SMAF9C5W7YGY7CT9371SEK	eur	{"value": "10", "precision": 20}	1	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	\N	10	\N	\N
price_01K4SMAF9DDA5GQQNJ7E02DP0F	\N	pset_01K4SMAF9DVCMNTY4AWMD7NNTX	usd	{"value": "10", "precision": 20}	0	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	\N	10	\N	\N
price_01K4SMAF9D8QJ8AGXB0STYPJSC	\N	pset_01K4SMAF9DVCMNTY4AWMD7NNTX	eur	{"value": "10", "precision": 20}	0	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	\N	10	\N	\N
price_01K4SMAF9DWPCEVMHXNEPK0HZY	\N	pset_01K4SMAF9DVCMNTY4AWMD7NNTX	eur	{"value": "10", "precision": 20}	1	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	\N	10	\N	\N
price_01K4SMAFCFCND6Q3W8E7G2EV92	\N	pset_01K4SMAFCFBK2B27N53G3ACSFZ	eur	{"value": "1299", "precision": 20}	0	2025-09-10 12:56:39.824+02	2025-09-10 12:56:39.824+02	\N	\N	1299	\N	\N
price_01K4SMAFCF5P55YPGME29EM436	\N	pset_01K4SMAFCFBK2B27N53G3ACSFZ	usd	{"value": "1299", "precision": 20}	0	2025-09-10 12:56:39.824+02	2025-09-10 12:56:39.824+02	\N	\N	1299	\N	\N
price_01K4SMAFCFGA3V145AMN5QKH01	\N	pset_01K4SMAFCGQTR8P5FYXFDFBPKD	eur	{"value": "1259", "precision": 20}	0	2025-09-10 12:56:39.824+02	2025-09-10 12:56:39.824+02	\N	\N	1259	\N	\N
price_01K4SMAFCGWQV7S7JRJCD771QB	\N	pset_01K4SMAFCGQTR8P5FYXFDFBPKD	usd	{"value": "1259", "precision": 20}	0	2025-09-10 12:56:39.824+02	2025-09-10 12:56:39.824+02	\N	\N	1259	\N	\N
price_01K4SMAFDVD7PGP71FSR18XS1A	\N	pset_01K4SMAFDW0WPCHCF6JHC6MTAB	eur	{"value": "59", "precision": 20}	0	2025-09-10 12:56:39.868+02	2025-09-10 12:56:39.868+02	\N	\N	59	\N	\N
price_01K4SMAFDVZNB783YM9CMWA34C	\N	pset_01K4SMAFDW0WPCHCF6JHC6MTAB	usd	{"value": "59", "precision": 20}	0	2025-09-10 12:56:39.868+02	2025-09-10 12:56:39.868+02	\N	\N	59	\N	\N
price_01K4SMAFDW58HHMPR868VEKR8K	\N	pset_01K4SMAFDWZEACQVHCZTAZSYRS	eur	{"value": "65", "precision": 20}	0	2025-09-10 12:56:39.868+02	2025-09-10 12:56:39.868+02	\N	\N	65	\N	\N
price_01K4SMAFDWWD9G0R2H5CS405RA	\N	pset_01K4SMAFDWZEACQVHCZTAZSYRS	usd	{"value": "65", "precision": 20}	0	2025-09-10 12:56:39.868+02	2025-09-10 12:56:39.868+02	\N	\N	65	\N	\N
price_01K4SMAFF66QCFDE5F4AR134MZ	\N	pset_01K4SMAFF6VGY4XKAVHZ0TRBSX	eur	{"value": "999", "precision": 20}	0	2025-09-10 12:56:39.91+02	2025-09-10 12:56:39.91+02	\N	\N	999	\N	\N
price_01K4SMAFF6TTXTFXGNPCGGAERC	\N	pset_01K4SMAFF6VGY4XKAVHZ0TRBSX	usd	{"value": "999", "precision": 20}	0	2025-09-10 12:56:39.911+02	2025-09-10 12:56:39.911+02	\N	\N	999	\N	\N
price_01K4SMAFF67ZT3P48VDY3TJ797	\N	pset_01K4SMAFF6QFRK3TGYV74Z73BT	eur	{"value": "959", "precision": 20}	0	2025-09-10 12:56:39.911+02	2025-09-10 12:56:39.911+02	\N	\N	959	\N	\N
price_01K4SMAFF6TNC7GV2R2B5ZK4TM	\N	pset_01K4SMAFF6QFRK3TGYV74Z73BT	usd	{"value": "959", "precision": 20}	0	2025-09-10 12:56:39.911+02	2025-09-10 12:56:39.911+02	\N	\N	959	\N	\N
price_01K4SMAFGG5PV8Q4ZVA4B21AW1	\N	pset_01K4SMAFGGB9RWN1171XMGP8XE	eur	{"value": "599", "precision": 20}	0	2025-09-10 12:56:39.952+02	2025-09-10 12:56:39.952+02	\N	\N	599	\N	\N
price_01K4SMAFGG59C2DSQVWPN3MY75	\N	pset_01K4SMAFGGB9RWN1171XMGP8XE	usd	{"value": "599", "precision": 20}	0	2025-09-10 12:56:39.952+02	2025-09-10 12:56:39.952+02	\N	\N	599	\N	\N
price_01K4SMAFGGGX5YEXAB4MKMS6Z4	\N	pset_01K4SMAFGGEHB78HA1F3E4906Z	eur	{"value": "599", "precision": 20}	0	2025-09-10 12:56:39.952+02	2025-09-10 12:56:39.952+02	\N	\N	599	\N	\N
price_01K4SMAFGGXXE9WC74YRXBC9G8	\N	pset_01K4SMAFGGEHB78HA1F3E4906Z	usd	{"value": "599", "precision": 20}	0	2025-09-10 12:56:39.952+02	2025-09-10 12:56:39.952+02	\N	\N	599	\N	\N
price_01K4SMAFHR4QW4R7SBZTBEN7DE	\N	pset_01K4SMAFHRP7SAJ0YRMRYDMASB	eur	{"value": "149", "precision": 20}	0	2025-09-10 12:56:39.992+02	2025-09-10 12:56:39.992+02	\N	\N	149	\N	\N
price_01K4SMAFHRWDXMJQERJVZEKXDM	\N	pset_01K4SMAFHRP7SAJ0YRMRYDMASB	usd	{"value": "149", "precision": 20}	0	2025-09-10 12:56:39.992+02	2025-09-10 12:56:39.992+02	\N	\N	149	\N	\N
price_01K4SMAFHRM42R38CEKSMJF68P	\N	pset_01K4SMAFHR86BMG4DHK80QY264	eur	{"value": "149", "precision": 20}	0	2025-09-10 12:56:39.992+02	2025-09-10 12:56:39.992+02	\N	\N	149	\N	\N
price_01K4SMAFHR1BBTACE9M4XRAJ71	\N	pset_01K4SMAFHR86BMG4DHK80QY264	usd	{"value": "149", "precision": 20}	0	2025-09-10 12:56:39.992+02	2025-09-10 12:56:39.992+02	\N	\N	149	\N	\N
price_01K4SMAFK0ZEW0X40A4W4V2ZER	\N	pset_01K4SMAFK0J05W0REN8TD1FAZ3	eur	{"value": "99", "precision": 20}	0	2025-09-10 12:56:40.032+02	2025-09-10 12:56:40.032+02	\N	\N	99	\N	\N
price_01K4SMAFK0WFJAC134HEHAKE8C	\N	pset_01K4SMAFK0J05W0REN8TD1FAZ3	usd	{"value": "99", "precision": 20}	0	2025-09-10 12:56:40.032+02	2025-09-10 12:56:40.032+02	\N	\N	99	\N	\N
price_01K4SMAFK0AXG6D7AKQZR1D8QN	\N	pset_01K4SMAFK0833Q5GHVBMVD7XNT	eur	{"value": "99", "precision": 20}	0	2025-09-10 12:56:40.032+02	2025-09-10 12:56:40.032+02	\N	\N	99	\N	\N
price_01K4SMAFK05G5APK4JS1E2MK3C	\N	pset_01K4SMAFK0833Q5GHVBMVD7XNT	usd	{"value": "99", "precision": 20}	0	2025-09-10 12:56:40.032+02	2025-09-10 12:56:40.032+02	\N	\N	99	\N	\N
price_01K4SMAFM6Q30M4JSGPKVQV5TA	\N	pset_01K4SMAFM6QARZJANZ54B7VDWT	eur	{"value": "79", "precision": 20}	0	2025-09-10 12:56:40.07+02	2025-09-10 12:56:40.07+02	\N	\N	79	\N	\N
price_01K4SMAFM69WA06SPVXKAX214Z	\N	pset_01K4SMAFM6QARZJANZ54B7VDWT	usd	{"value": "79", "precision": 20}	0	2025-09-10 12:56:40.07+02	2025-09-10 12:56:40.07+02	\N	\N	79	\N	\N
price_01K4SMAFM6J18R7V8KKHEQM3VS	\N	pset_01K4SMAFM62XES7HST710GKRW6	eur	{"value": "79", "precision": 20}	0	2025-09-10 12:56:40.07+02	2025-09-10 12:56:40.07+02	\N	\N	79	\N	\N
price_01K4SMAFM6C7T3VAWPV0T37HJE	\N	pset_01K4SMAFM62XES7HST710GKRW6	usd	{"value": "79", "precision": 20}	0	2025-09-10 12:56:40.07+02	2025-09-10 12:56:40.07+02	\N	\N	79	\N	\N
price_01K4SMAFNEVH8TN2E83QBYMRBE	\N	pset_01K4SMAFNEKKFMDFFJ82GT9KY0	eur	{"value": "79", "precision": 20}	0	2025-09-10 12:56:40.11+02	2025-09-10 12:56:40.11+02	\N	\N	79	\N	\N
price_01K4SMAFNEJH3BEJ73535BGQHJ	\N	pset_01K4SMAFNEKKFMDFFJ82GT9KY0	usd	{"value": "79", "precision": 20}	0	2025-09-10 12:56:40.11+02	2025-09-10 12:56:40.11+02	\N	\N	79	\N	\N
price_01K4SMAFNE85Z2VDZZ1RHX006T	\N	pset_01K4SMAFNEVJ1HV9C5G52DH4C3	eur	{"value": "55", "precision": 20}	0	2025-09-10 12:56:40.11+02	2025-09-10 12:56:40.11+02	\N	\N	55	\N	\N
price_01K4SMAFNEBM1XRJSHN4Z8PJV7	\N	pset_01K4SMAFNEVJ1HV9C5G52DH4C3	usd	{"value": "55", "precision": 20}	0	2025-09-10 12:56:40.11+02	2025-09-10 12:56:40.11+02	\N	\N	55	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01K4SMAF5QQXTHV9SJ3XT73ZM9	currency_code	eur	f	2025-09-10 12:56:39.607+02	2025-09-10 12:56:39.607+02	\N
prpref_01K4SMAF6H1YX78W7W3546YHAC	currency_code	usd	f	2025-09-10 12:56:39.633+02	2025-09-10 12:56:39.633+02	\N
prpref_01K4SMAF72EGS89XGDD345M02Z	region_id	reg_01K4SMAF6Q56P0DB7GRM9TBN94	f	2025-09-10 12:56:39.65+02	2025-09-10 12:56:39.65+02	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
prule_01K4SMAF9C9E1NAFRA87DC1WAE	reg_01K4SMAF6Q56P0DB7GRM9TBN94	0	price_01K4SMAF9CK5VNZE27SSMBZXYP	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	region_id	eq
prule_01K4SMAF9D3ZY44WPWSS6BV479	reg_01K4SMAF6Q56P0DB7GRM9TBN94	0	price_01K4SMAF9DWPCEVMHXNEPK0HZY	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N	region_id	eq
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01K4SMAF9C5W7YGY7CT9371SEK	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N
pset_01K4SMAF9DVCMNTY4AWMD7NNTX	2025-09-10 12:56:39.725+02	2025-09-10 12:56:39.725+02	\N
pset_01K4SMAFCFBK2B27N53G3ACSFZ	2025-09-10 12:56:39.824+02	2025-09-10 12:56:39.824+02	\N
pset_01K4SMAFCGQTR8P5FYXFDFBPKD	2025-09-10 12:56:39.824+02	2025-09-10 12:56:39.824+02	\N
pset_01K4SMAFDW0WPCHCF6JHC6MTAB	2025-09-10 12:56:39.868+02	2025-09-10 12:56:39.868+02	\N
pset_01K4SMAFDWZEACQVHCZTAZSYRS	2025-09-10 12:56:39.868+02	2025-09-10 12:56:39.868+02	\N
pset_01K4SMAFF6VGY4XKAVHZ0TRBSX	2025-09-10 12:56:39.91+02	2025-09-10 12:56:39.91+02	\N
pset_01K4SMAFF6QFRK3TGYV74Z73BT	2025-09-10 12:56:39.91+02	2025-09-10 12:56:39.91+02	\N
pset_01K4SMAFGGB9RWN1171XMGP8XE	2025-09-10 12:56:39.952+02	2025-09-10 12:56:39.952+02	\N
pset_01K4SMAFGGEHB78HA1F3E4906Z	2025-09-10 12:56:39.952+02	2025-09-10 12:56:39.952+02	\N
pset_01K4SMAFHRP7SAJ0YRMRYDMASB	2025-09-10 12:56:39.992+02	2025-09-10 12:56:39.992+02	\N
pset_01K4SMAFHR86BMG4DHK80QY264	2025-09-10 12:56:39.992+02	2025-09-10 12:56:39.992+02	\N
pset_01K4SMAFK0J05W0REN8TD1FAZ3	2025-09-10 12:56:40.032+02	2025-09-10 12:56:40.032+02	\N
pset_01K4SMAFK0833Q5GHVBMVD7XNT	2025-09-10 12:56:40.032+02	2025-09-10 12:56:40.032+02	\N
pset_01K4SMAFM6QARZJANZ54B7VDWT	2025-09-10 12:56:40.07+02	2025-09-10 12:56:40.07+02	\N
pset_01K4SMAFM62XES7HST710GKRW6	2025-09-10 12:56:40.07+02	2025-09-10 12:56:40.07+02	\N
pset_01K4SMAFNEKKFMDFFJ82GT9KY0	2025-09-10 12:56:40.11+02	2025-09-10 12:56:40.11+02	\N
pset_01K4SMAFNEVJ1HV9C5G52DH4C3	2025-09-10 12:56:40.11+02	2025-09-10 12:56:40.11+02	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	16" Ultra-Slim AI Laptop | 3K OLED | 1.1cm Thin | 6-Speaker Audio	16-ultra-slim-ai-laptop-3k-oled-11cm-thin-6-speaker-audio	\N	This ultra-thin 16-inch laptop is a sophisticated, high-performance machine for the new era of artificial intelligence. It has been completely redesigned from the inside out. The cabinet features an exquisite new ceramic-aluminum composite material in a range of nature-inspired colors. This material provides durability while completing the ultra-slim design and resisting the test of time. This innovative computer utilizes the latest AI-enhanced processor with quiet ambient cooling. It's designed to enrich your lifestyle on the go with an astonishingly thin 1.1cm chassis that houses an advanced 16-inch 3K OLED display and immersive six-speaker audio.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/laptop-front.png	400	\N	\N	\N	\N	\N	\N	\N	pcol_01K4SMAFANG6BCJC0EWQSG8CHS	\N	t	\N	2025-09-10 12:56:39.785+02	2025-09-10 12:56:39.785+02	\N	\N
prod_01K4SMAFD3474PBAS6AH4WA2TD	1080p HD Pro Webcam | Superior Video | Privacy enabled	1080p-hd-pro-webcam-superior-video-privacy-enabled	\N	High-quality 1080p HD webcam that elevates your work environment with superior video and audio that outperforms standard laptop cameras. Achieve top-tier video collaboration at a cost-effective price point, ideal for widespread deployment across your organization.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/camera-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-10 12:56:39.844+02	2025-09-10 12:56:39.844+02	\N	\N
prod_01K4SMAFEDYWQRAJDZBMNPDXWF	6.5" Ultra HD Smartphone | 3x Impact-Resistant Screen	65-ultra-hd-smartphone-3x-impact-resistant-screen	\N	This premium smartphone is crafted from durable and lightweight aerospace-grade aluminum, featuring an expansive 6.5" Ultra-High Definition AMOLED display. It boasts exceptional durability with a cutting-edge nanocrystal glass front, offering three times the impact resistance of standard smartphone screens. The device combines sleek design with robust protection, setting a new standard for smartphone resilience and visual excellence. Copy	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/phone-front.png	400	\N	\N	\N	\N	\N	\N	\N	pcol_01K4SMAFANG6BCJC0EWQSG8CHS	\N	t	\N	2025-09-10 12:56:39.885+02	2025-09-10 12:56:39.885+02	\N	\N
prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	34" QD-OLED Curved Gaming Monitor | Ultra-Wide | Infinite Contrast | 175Hz	34-qd-oled-curved-gaming-monitor-ultra-wide-infinite-contrast-175hz	\N	Experience the pinnacle of display technology with this 34-inch curved monitor. By merging OLED panels and Quantum Dot technology, this QD-OLED screen delivers exceptional contrast, deep blacks, unlimited viewing angles, and vivid colors. The curved design provides an immersive experience, allowing you to enjoy the best of both worlds in one cutting-edge display. This innovative monitor represents the ultimate fusion of visual performance and immersive design.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/screen-front.png	400	\N	\N	\N	\N	\N	\N	\N	pcol_01K4SMAFANG6BCJC0EWQSG8CHS	\N	t	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N	\N
prod_01K4SMAFH0PXTG0BQ4R3FZFMGF	Hi-Fi Gaming Headset | Pro-Grade DAC | Hi-Res Certified	hi-fi-gaming-headset-pro-grade-dac-hi-res-certified	\N	Experience studio-quality audio with this advanced acoustic system, which pairs premium hardware with high-fidelity sound and innovative audio software for an immersive listening experience. The integrated digital-to-analog converter (DAC) enhances the audio setup with high-resolution certification and a built-in amplifier, delivering exceptional sound clarity and depth. This comprehensive audio solution brings professional-grade sound to your personal environment, whether for gaming, music production, or general entertainment.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/headphone-front.png	400	\N	\N	\N	\N	\N	\N	\N	pcol_01K4SMAFANG6BCJC0EWQSG8CHS	\N	t	\N	2025-09-10 12:56:39.968+02	2025-09-10 12:56:39.968+02	\N	\N
prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX	Wireless Keyboard | Touch ID | Numeric Keypad	wireless-keyboard-touch-id-numeric-keypad	\N	This wireless keyboard offers a comfortable typing experience with a numeric keypad and Touch ID. It features navigation buttons, full-sized arrow keys, and is ideal for spreadsheets and gaming. The rechargeable battery lasts about a month. It pairs automatically with compatible computers and includes a USB-C to Lightning cable for charging and pairing.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/keyboard-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-10 12:56:40.009+02	2025-09-10 12:56:40.009+02	\N	\N
prod_01K4SMAFKF8Z91Z9BH77TATWP0	Wireless Rechargeable Mouse | Multi-Touch Surface	wireless-rechargeable-mouse-multi-touch-surface	\N	This wireless keyboard offers a comfortable typing experience with a numeric keypad and Touch ID. It features navigation buttons, full-sized arrow keys, and is ideal for spreadsheets and gaming. The rechargeable battery lasts about a month. It pairs automatically with compatible computers and includes a USB-C to Lightning cable for charging and pairing.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/mouse-top.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-10 12:56:40.048+02	2025-09-10 12:56:40.048+02	\N	\N
prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	Conference Speaker | High-Performance | Budget-Friendly	conference-speaker-high-performance-budget-friendly	\N	This compact, powerful conference speaker offers exceptional, high-performance features at a surprisingly affordable price. Packed with advanced productivity-enhancing technology, it delivers premium functionality without the premium price tag. Experience better meetings and improved communication, regardless of where your team members are calling from.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/speaker-top.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-10 12:56:40.086+02	2025-09-10 12:56:40.086+02	\N	\N
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01K4SMAFB0QTBRH2QHZD49NQDS	Laptops		laptops	pcat_01K4SMAFB0QTBRH2QHZD49NQDS	t	f	0	\N	2025-09-10 12:56:39.776+02	2025-09-10 12:56:39.776+02	\N	\N
pcat_01K4SMAFB0R1EA86NVNZ116S8B	Accessories		accessories	pcat_01K4SMAFB0R1EA86NVNZ116S8B	t	f	1	\N	2025-09-10 12:56:39.777+02	2025-09-10 12:56:39.777+02	\N	\N
pcat_01K4SMAFB0Q2FSYBS9PVBTJFKS	Phones		phones	pcat_01K4SMAFB0Q2FSYBS9PVBTJFKS	t	f	2	\N	2025-09-10 12:56:39.777+02	2025-09-10 12:56:39.777+02	\N	\N
pcat_01K4SMAFB0NBA21Z6VMZAG80H8	Monitors		monitors	pcat_01K4SMAFB0NBA21Z6VMZAG80H8	t	f	3	\N	2025-09-10 12:56:39.777+02	2025-09-10 12:56:39.777+02	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	pcat_01K4SMAFB0QTBRH2QHZD49NQDS
prod_01K4SMAFD3474PBAS6AH4WA2TD	pcat_01K4SMAFB0R1EA86NVNZ116S8B
prod_01K4SMAFEDYWQRAJDZBMNPDXWF	pcat_01K4SMAFB0Q2FSYBS9PVBTJFKS
prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	pcat_01K4SMAFB0NBA21Z6VMZAG80H8
prod_01K4SMAFH0PXTG0BQ4R3FZFMGF	pcat_01K4SMAFB0R1EA86NVNZ116S8B
prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX	pcat_01K4SMAFB0R1EA86NVNZ116S8B
prod_01K4SMAFKF8Z91Z9BH77TATWP0	pcat_01K4SMAFB0R1EA86NVNZ116S8B
prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	pcat_01K4SMAFB0R1EA86NVNZ116S8B
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
pcol_01K4SMAFANG6BCJC0EWQSG8CHS	Featured	featured	\N	2025-09-10 12:56:39.764711+02	2025-09-10 12:56:39.764711+02	\N
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01K4SMAFB9XVV2YFG73PRSEJZ3	Storage	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N
opt_01K4SMAFB9TRR3J4RZT0DJY49D	Color	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N
opt_01K4SMAFD320HR21Q7321ABGPA	Color	prod_01K4SMAFD3474PBAS6AH4WA2TD	\N	2025-09-10 12:56:39.844+02	2025-09-10 12:56:39.844+02	\N
opt_01K4SMAFED5NCVWDYCG41EM7WR	Memory	prod_01K4SMAFEDYWQRAJDZBMNPDXWF	\N	2025-09-10 12:56:39.885+02	2025-09-10 12:56:39.885+02	\N
opt_01K4SMAFED6YSA4EAJA4028BSJ	Color	prod_01K4SMAFEDYWQRAJDZBMNPDXWF	\N	2025-09-10 12:56:39.885+02	2025-09-10 12:56:39.885+02	\N
opt_01K4SMAFFRSJEPSN4V8MAVZ5V9	Color	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N
opt_01K4SMAFH0HJ3XXRA05P1SR72P	Color	prod_01K4SMAFH0PXTG0BQ4R3FZFMGF	\N	2025-09-10 12:56:39.968+02	2025-09-10 12:56:39.968+02	\N
opt_01K4SMAFJ8N8CPS1N1ATP5HWN5	Color	prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX	\N	2025-09-10 12:56:40.009+02	2025-09-10 12:56:40.009+02	\N
opt_01K4SMAFKFYDSN4TZ1DYYAZGHY	Color	prod_01K4SMAFKF8Z91Z9BH77TATWP0	\N	2025-09-10 12:56:40.048+02	2025-09-10 12:56:40.048+02	\N
opt_01K4SMAFMNDPFNRCRXHMWK0WFX	Color	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	\N	2025-09-10 12:56:40.086+02	2025-09-10 12:56:40.086+02	\N
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01K4SMAFB8YQ7SH05S100TTKG7	256 GB	opt_01K4SMAFB9XVV2YFG73PRSEJZ3	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N
optval_01K4SMAFB995C6ZE9EMDE6N63R	512 GB	opt_01K4SMAFB9XVV2YFG73PRSEJZ3	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N
optval_01K4SMAFB9P15SRJWKTFB4DVJ1	Blue	opt_01K4SMAFB9TRR3J4RZT0DJY49D	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N
optval_01K4SMAFB95YYH6V7WKZEVA9VB	Red	opt_01K4SMAFB9TRR3J4RZT0DJY49D	\N	2025-09-10 12:56:39.786+02	2025-09-10 12:56:39.786+02	\N
optval_01K4SMAFD387YSWMR9H4N57ZM8	Black	opt_01K4SMAFD320HR21Q7321ABGPA	\N	2025-09-10 12:56:39.844+02	2025-09-10 12:56:39.844+02	\N
optval_01K4SMAFD3WC8B393YHZWS51AX	White	opt_01K4SMAFD320HR21Q7321ABGPA	\N	2025-09-10 12:56:39.844+02	2025-09-10 12:56:39.844+02	\N
optval_01K4SMAFEDYDBYXD3K7JAX0F2V	256 GB	opt_01K4SMAFED5NCVWDYCG41EM7WR	\N	2025-09-10 12:56:39.885+02	2025-09-10 12:56:39.885+02	\N
optval_01K4SMAFED7VSG8J1S28E4CPP2	512 GB	opt_01K4SMAFED5NCVWDYCG41EM7WR	\N	2025-09-10 12:56:39.885+02	2025-09-10 12:56:39.885+02	\N
optval_01K4SMAFEDNBJ6CNFRX4DB1FKT	Purple	opt_01K4SMAFED6YSA4EAJA4028BSJ	\N	2025-09-10 12:56:39.886+02	2025-09-10 12:56:39.886+02	\N
optval_01K4SMAFED2KR0JAJ7Y3Q932Q6	Red	opt_01K4SMAFED6YSA4EAJA4028BSJ	\N	2025-09-10 12:56:39.886+02	2025-09-10 12:56:39.886+02	\N
optval_01K4SMAFFRW4N49G7KZQFHSW0G	White	opt_01K4SMAFFRSJEPSN4V8MAVZ5V9	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N
optval_01K4SMAFFRXCJFF26N2MNQXW7G	Black	opt_01K4SMAFFRSJEPSN4V8MAVZ5V9	\N	2025-09-10 12:56:39.929+02	2025-09-10 12:56:39.929+02	\N
optval_01K4SMAFH0QNHPFCJ3VBFSVKF5	Black	opt_01K4SMAFH0HJ3XXRA05P1SR72P	\N	2025-09-10 12:56:39.968+02	2025-09-10 12:56:39.968+02	\N
optval_01K4SMAFH0ZNXPDMBWSDHE6GWG	White	opt_01K4SMAFH0HJ3XXRA05P1SR72P	\N	2025-09-10 12:56:39.968+02	2025-09-10 12:56:39.968+02	\N
optval_01K4SMAFJ8F2YMQCSC1QTVGQ3M	Black	opt_01K4SMAFJ8N8CPS1N1ATP5HWN5	\N	2025-09-10 12:56:40.009+02	2025-09-10 12:56:40.009+02	\N
optval_01K4SMAFJ8W9M9T7AAYX4XP97Y	White	opt_01K4SMAFJ8N8CPS1N1ATP5HWN5	\N	2025-09-10 12:56:40.009+02	2025-09-10 12:56:40.009+02	\N
optval_01K4SMAFKFN5WXG24971G79BCH	Black	opt_01K4SMAFKFYDSN4TZ1DYYAZGHY	\N	2025-09-10 12:56:40.048+02	2025-09-10 12:56:40.048+02	\N
optval_01K4SMAFKFXFF3GMVJV2V69RJ6	White	opt_01K4SMAFKFYDSN4TZ1DYYAZGHY	\N	2025-09-10 12:56:40.048+02	2025-09-10 12:56:40.048+02	\N
optval_01K4SMAFMN92S7M7B7D985M8AF	Black	opt_01K4SMAFMNDPFNRCRXHMWK0WFX	\N	2025-09-10 12:56:40.086+02	2025-09-10 12:56:40.086+02	\N
optval_01K4SMAFMNJFT3DFQA0ZRG9BBS	White	opt_01K4SMAFMNDPFNRCRXHMWK0WFX	\N	2025-09-10 12:56:40.086+02	2025-09-10 12:56:40.086+02	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFBKH5E9BJ63SM04C615	2025-09-10 12:56:39.795238+02	2025-09-10 12:56:39.795238+02	\N
prod_01K4SMAFD3474PBAS6AH4WA2TD	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFDAATQDWEWNDA7WF7MT	2025-09-10 12:56:39.849893+02	2025-09-10 12:56:39.849893+02	\N
prod_01K4SMAFEDYWQRAJDZBMNPDXWF	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFEMJ13EBAD3810R06T3	2025-09-10 12:56:39.892056+02	2025-09-10 12:56:39.892056+02	\N
prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFFZ0D9MA2NAQ24YPAKY	2025-09-10 12:56:39.935221+02	2025-09-10 12:56:39.935221+02	\N
prod_01K4SMAFH0PXTG0BQ4R3FZFMGF	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFH73BK30QS0B3CZWMCS	2025-09-10 12:56:39.975251+02	2025-09-10 12:56:39.975251+02	\N
prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFJFSZPGCH3DXG6Y7E90	2025-09-10 12:56:40.015005+02	2025-09-10 12:56:40.015005+02	\N
prod_01K4SMAFKF8Z91Z9BH77TATWP0	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFKN970X2W7RBBEKB8GT	2025-09-10 12:56:40.053384+02	2025-09-10 12:56:40.053384+02	\N
prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	prodsc_01K4SMAFMWKR4NT798D6WVDX9V	2025-09-10 12:56:40.092131+02	2025-09-10 12:56:40.092131+02	\N
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K4SMAFC1GHM2N13S4DN6QTE7	256 GB / Blue	256-BLUE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	2025-09-10 12:56:39.81+02	2025-09-10 12:56:39.81+02	\N
variant_01K4SMAFC1Y8ZVF41HRH3DY0VG	512 GB / Red	512-RED	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFB8K0HS0EQ6V9PRQGN5	2025-09-10 12:56:39.81+02	2025-09-10 12:56:39.81+02	\N
variant_01K4SMAFDJ46V7D38TK0666FFX	Webcam Black	WEBCAM-BLACK	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFD3474PBAS6AH4WA2TD	2025-09-10 12:56:39.858+02	2025-09-10 12:56:39.858+02	\N
variant_01K4SMAFDJ9HW9YK6RF71HTZF7	Webcam White	WEBCAM-WHITE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFD3474PBAS6AH4WA2TD	2025-09-10 12:56:39.858+02	2025-09-10 12:56:39.858+02	\N
variant_01K4SMAFEW2X2NBC9T3EMFEXYJ	256 GB Purple	PHONE-256-PURPLE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFEDYWQRAJDZBMNPDXWF	2025-09-10 12:56:39.901+02	2025-09-10 12:56:39.901+02	\N
variant_01K4SMAFEWF4BBWV37EMKV4GWR	256 GB Red	PHONE-256-RED	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFEDYWQRAJDZBMNPDXWF	2025-09-10 12:56:39.901+02	2025-09-10 12:56:39.901+02	\N
variant_01K4SMAFG7H2NCX5YWTECHH9SC	ACME Monitor 4k White	ACME-MONITOR-WHITE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	2025-09-10 12:56:39.943+02	2025-09-10 12:56:39.943+02	\N
variant_01K4SMAFG746NFPNQWJ4MZRBJ5	ACME Monitor 4k White	ACME-MONITOR-BLACK	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFFRDVQ1GJR6W5MHMRYP	2025-09-10 12:56:39.943+02	2025-09-10 12:56:39.943+02	\N
variant_01K4SMAFHF1JA42RB0RR9FRVME	Headphone Black	HEADPHONE-BLACK	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFH0PXTG0BQ4R3FZFMGF	2025-09-10 12:56:39.983+02	2025-09-10 12:56:39.983+02	\N
variant_01K4SMAFHFQ9TFC4RKY11F7J77	Headphone White	HEADPHONE-WHITE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFH0PXTG0BQ4R3FZFMGF	2025-09-10 12:56:39.983+02	2025-09-10 12:56:39.983+02	\N
variant_01K4SMAFJQHBR6KZ38QEY61TME	Keyboard Black	KEYBOARD-BLACK	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX	2025-09-10 12:56:40.023+02	2025-09-10 12:56:40.023+02	\N
variant_01K4SMAFJQD19FD3SXXAEAYF0A	Keyboard White	KEYBOARD-WHITE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFJ8H1H3Z3ARG4MC5RTX	2025-09-10 12:56:40.023+02	2025-09-10 12:56:40.023+02	\N
variant_01K4SMAFKXJGNSPMFC4VF7GSDW	Mouse Black	MOUSE-BLACK	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFKF8Z91Z9BH77TATWP0	2025-09-10 12:56:40.061+02	2025-09-10 12:56:40.061+02	\N
variant_01K4SMAFKX1ZBEQH9JZT2KTM8X	Mouse White	MOUSE-WHITE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFKF8Z91Z9BH77TATWP0	2025-09-10 12:56:40.061+02	2025-09-10 12:56:40.061+02	\N
variant_01K4SMAFN434CQDX67W374CZ8Y	Speaker Black	SPEAKER-BLACK	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	2025-09-10 12:56:40.1+02	2025-09-10 12:56:40.1+02	\N
variant_01K4SMAFN4T2MAH09C3Q3B9Y6N	Speaker White	SPEAKER-WHITE	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K4SMAFMNQ4Y2EGB3Y2WBMDAC	2025-09-10 12:56:40.1+02	2025-09-10 12:56:40.1+02	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01K4SMAFC1GHM2N13S4DN6QTE7	optval_01K4SMAFB8YQ7SH05S100TTKG7
variant_01K4SMAFC1GHM2N13S4DN6QTE7	optval_01K4SMAFB9P15SRJWKTFB4DVJ1
variant_01K4SMAFC1Y8ZVF41HRH3DY0VG	optval_01K4SMAFB995C6ZE9EMDE6N63R
variant_01K4SMAFC1Y8ZVF41HRH3DY0VG	optval_01K4SMAFB95YYH6V7WKZEVA9VB
variant_01K4SMAFDJ46V7D38TK0666FFX	optval_01K4SMAFD387YSWMR9H4N57ZM8
variant_01K4SMAFDJ9HW9YK6RF71HTZF7	optval_01K4SMAFD3WC8B393YHZWS51AX
variant_01K4SMAFEW2X2NBC9T3EMFEXYJ	optval_01K4SMAFEDYDBYXD3K7JAX0F2V
variant_01K4SMAFEW2X2NBC9T3EMFEXYJ	optval_01K4SMAFEDNBJ6CNFRX4DB1FKT
variant_01K4SMAFEWF4BBWV37EMKV4GWR	optval_01K4SMAFEDYDBYXD3K7JAX0F2V
variant_01K4SMAFEWF4BBWV37EMKV4GWR	optval_01K4SMAFED2KR0JAJ7Y3Q932Q6
variant_01K4SMAFG7H2NCX5YWTECHH9SC	optval_01K4SMAFFRW4N49G7KZQFHSW0G
variant_01K4SMAFG746NFPNQWJ4MZRBJ5	optval_01K4SMAFFRXCJFF26N2MNQXW7G
variant_01K4SMAFHF1JA42RB0RR9FRVME	optval_01K4SMAFH0QNHPFCJ3VBFSVKF5
variant_01K4SMAFHFQ9TFC4RKY11F7J77	optval_01K4SMAFH0ZNXPDMBWSDHE6GWG
variant_01K4SMAFJQHBR6KZ38QEY61TME	optval_01K4SMAFJ8F2YMQCSC1QTVGQ3M
variant_01K4SMAFJQD19FD3SXXAEAYF0A	optval_01K4SMAFJ8W9M9T7AAYX4XP97Y
variant_01K4SMAFKXJGNSPMFC4VF7GSDW	optval_01K4SMAFKFN5WXG24971G79BCH
variant_01K4SMAFKX1ZBEQH9JZT2KTM8X	optval_01K4SMAFKFXFF3GMVJV2V69RJ6
variant_01K4SMAFN434CQDX67W374CZ8Y	optval_01K4SMAFMN92S7M7B7D985M8AF
variant_01K4SMAFN4T2MAH09C3Q3B9Y6N	optval_01K4SMAFMNJFT3DFQA0ZRG9BBS
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K4SMAFC1GHM2N13S4DN6QTE7	pset_01K4SMAFCFBK2B27N53G3ACSFZ	pvps_01K4SMAFCRT6J8BNC055DGS39X	2025-09-10 12:56:39.832586+02	2025-09-10 12:56:39.832586+02	\N
variant_01K4SMAFC1Y8ZVF41HRH3DY0VG	pset_01K4SMAFCGQTR8P5FYXFDFBPKD	pvps_01K4SMAFCSQ4SVQSSWTE230YCA	2025-09-10 12:56:39.832586+02	2025-09-10 12:56:39.832586+02	\N
variant_01K4SMAFDJ46V7D38TK0666FFX	pset_01K4SMAFDW0WPCHCF6JHC6MTAB	pvps_01K4SMAFE4V6T16535BC0AW31S	2025-09-10 12:56:39.876258+02	2025-09-10 12:56:39.876258+02	\N
variant_01K4SMAFDJ9HW9YK6RF71HTZF7	pset_01K4SMAFDWZEACQVHCZTAZSYRS	pvps_01K4SMAFE4XQDJRTZ2NBAZ770G	2025-09-10 12:56:39.876258+02	2025-09-10 12:56:39.876258+02	\N
variant_01K4SMAFEW2X2NBC9T3EMFEXYJ	pset_01K4SMAFF6VGY4XKAVHZ0TRBSX	pvps_01K4SMAFFF6MWHKPE4JXRATKSN	2025-09-10 12:56:39.919152+02	2025-09-10 12:56:39.919152+02	\N
variant_01K4SMAFEWF4BBWV37EMKV4GWR	pset_01K4SMAFF6QFRK3TGYV74Z73BT	pvps_01K4SMAFFF5ARDF2GQHR1NBKAZ	2025-09-10 12:56:39.919152+02	2025-09-10 12:56:39.919152+02	\N
variant_01K4SMAFG7H2NCX5YWTECHH9SC	pset_01K4SMAFGGB9RWN1171XMGP8XE	pvps_01K4SMAFGR1YBXY9KM967Z0PJW	2025-09-10 12:56:39.960349+02	2025-09-10 12:56:39.960349+02	\N
variant_01K4SMAFG746NFPNQWJ4MZRBJ5	pset_01K4SMAFGGEHB78HA1F3E4906Z	pvps_01K4SMAFGR2RXQJMDTBZTRG2F7	2025-09-10 12:56:39.960349+02	2025-09-10 12:56:39.960349+02	\N
variant_01K4SMAFHF1JA42RB0RR9FRVME	pset_01K4SMAFHRP7SAJ0YRMRYDMASB	pvps_01K4SMAFHZE9EBD5SBNVC94Z8T	2025-09-10 12:56:39.999807+02	2025-09-10 12:56:39.999807+02	\N
variant_01K4SMAFHFQ9TFC4RKY11F7J77	pset_01K4SMAFHR86BMG4DHK80QY264	pvps_01K4SMAFHZDMVEGB6Q3TCXM4H2	2025-09-10 12:56:39.999807+02	2025-09-10 12:56:39.999807+02	\N
variant_01K4SMAFJQHBR6KZ38QEY61TME	pset_01K4SMAFK0J05W0REN8TD1FAZ3	pvps_01K4SMAFK7ND2SD0AS3HZNP7PH	2025-09-10 12:56:40.039503+02	2025-09-10 12:56:40.039503+02	\N
variant_01K4SMAFJQD19FD3SXXAEAYF0A	pset_01K4SMAFK0833Q5GHVBMVD7XNT	pvps_01K4SMAFK72N37NH0GXF33YGJV	2025-09-10 12:56:40.039503+02	2025-09-10 12:56:40.039503+02	\N
variant_01K4SMAFKXJGNSPMFC4VF7GSDW	pset_01K4SMAFM6QARZJANZ54B7VDWT	pvps_01K4SMAFMDNRK04VK9JMWJFGW9	2025-09-10 12:56:40.077802+02	2025-09-10 12:56:40.077802+02	\N
variant_01K4SMAFKX1ZBEQH9JZT2KTM8X	pset_01K4SMAFM62XES7HST710GKRW6	pvps_01K4SMAFMDQCE97CQA4BKBAG73	2025-09-10 12:56:40.077802+02	2025-09-10 12:56:40.077802+02	\N
variant_01K4SMAFN434CQDX67W374CZ8Y	pset_01K4SMAFNEKKFMDFFJ82GT9KY0	pvps_01K4SMAFNNH153X8TRRQD8HT3D	2025-09-10 12:56:40.117743+02	2025-09-10 12:56:40.117743+02	\N
variant_01K4SMAFN4T2MAH09C3Q3B9Y6N	pset_01K4SMAFNEVJ1HV9C5G52DH4C3	pvps_01K4SMAFNN567F539NWAEDYE17	2025-09-10 12:56:40.117743+02	2025-09-10 12:56:40.117743+02	\N
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01K4SMAHPED0FVPS1N81TH4Q5P	admin@test.com	emailpass	authid_01K4SMAHPFVWVBPFZ8HTBDT6VP	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAY9jV6xKRCRCiZHtxqnpJBuESITymniEoIbhWTqOfIsjAbBD7bXhZ5cHzsmL2t6+xkMw4+k7DY+HHj86Pabs9GBw2d7jRjTPP+5oifaE3qnU"}	2025-09-10 12:56:42.191+02	2025-09-10 12:56:42.191+02	\N
01K4TK99H5N0HAKQPJ64DRS1WD	nagy.viktordp@gmail.com	emailpass	authid_01K4TK99H514S99H5VF47NHSA4	\N	{"password": "c2NyeXB0AA8AAAAIAAAAATHH9TIEz+4QdV5x06BbzOA6Y7QgDgZl2J3Cax2PiWY2yXQI7kX+On4iemKZWjZ0HlFd7+VCIC6e6vtWw4J8wxhzw5tAkHngFZkhPdwbyLBv"}	2025-09-10 21:57:46.917+02	2025-09-10 21:57:46.917+02	\N
01K5YBMGMZMFGKT8RKD4K4B6JT	admin@teherguminet.hu	emailpass	authid_01K5YBMGMZ5N167SX9Y8AW93B2	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAVk3zh9PrMccEaMSv9tazjR3w9kXncgN5fsyzb2S8qDbFBMZ2PsROxO1ursI2cIRGN8MvF5M2/I5nzIYMoLtM+mtCWMrYH941JYUCmgzbdnt"}	2025-09-24 19:16:45.599+02	2025-09-24 19:16:45.599+02	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01K4SMAFA87MNM0CHNZW64P5S1	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	pksc_01K4SMAFAE1TM49ZMFEFW3AJGP	2025-09-10 12:56:39.758522+02	2025-09-10 12:56:39.758522+02	\N
\.


--
-- Data for Name: quote; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.quote (id, status, customer_id, draft_order_id, order_change_id, cart_id, created_at, updated_at, deleted_at) FROM stdin;
quo_01K4TNV6TY98FAPNJK1N70FC92	pending_merchant	cus_01K4TK99J1MVJ5NH0SFTQ9EWA2	order_01K4TNV6RR9NEKVVH38ZS47TQR	ordch_01K4TNV6TQPVE1P90184K4EJE9	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	2025-09-10 22:42:31.134+02	2025-09-10 22:42:31.134+02	\N
quo_01K4TNZQMTBMQ41KJH4AZY8PNR	pending_merchant	cus_01K4TK99J1MVJ5NH0SFTQ9EWA2	order_01K4TNZQK4G5N4K2PQVY084BP1	ordch_01K4TNZQMMY40DP3G95YJGZFX3	cart_01K4SVNZST3AC2ZXWG0DY4BQHD	2025-09-10 22:44:59.418+02	2025-09-10 22:44:59.418+02	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01K4SMAF6Q56P0DB7GRM9TBN94	Europe	eur	\N	2025-09-10 12:56:39.642+02	2025-09-10 12:56:39.642+02	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-09-10 12:56:36.938+02	2025-09-10 12:56:36.938+02	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ca	can	124	CANADA	Canada	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cn	chn	156	CHINA	China	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
in	ind	356	INDIA	India	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 12:56:36.939+02	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ml	mli	466	MALI	Mali	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
np	npl	524	NEPAL	Nepal	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
om	omn	512	OMAN	Oman	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pe	per	604	PERU	Peru	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
us	usa	840	UNITED STATES	United States	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 12:56:36.94+02	\N
dk	dnk	208	DENMARK	Denmark	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 22:06:11.869+02	\N
fr	fra	250	FRANCE	France	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 22:06:11.869+02	\N
de	deu	276	GERMANY	Germany	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 22:06:11.869+02	\N
it	ita	380	ITALY	Italy	\N	\N	2025-09-10 12:56:36.939+02	2025-09-10 22:06:11.869+02	\N
es	esp	724	SPAIN	Spain	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 22:06:11.869+02	\N
sk	svk	703	SLOVAKIA	Slovakia	reg_01K4SMAF6Q56P0DB7GRM9TBN94	\N	2025-09-10 12:56:36.94+02	2025-09-10 22:06:46.291+02	\N
se	swe	752	SWEDEN	Sweden	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 22:06:11.869+02	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	\N	\N	2025-09-10 12:56:36.94+02	2025-09-10 22:06:11.869+02	\N
hu	hun	348	HUNGARY	Hungary	reg_01K4SMAF6Q56P0DB7GRM9TBN94	\N	2025-09-10 12:56:36.939+02	2025-09-10 22:06:46.291+02	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01K4SMAF6Q56P0DB7GRM9TBN94	pp_system_default	regpp_01K4SMAF76C3KDATPXYWH0DMXP	2025-09-10 12:56:39.653825+02	2025-09-10 12:56:39.653825+02	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	Eladási csatorna		f	\N	2025-09-10 12:56:39.577+02	2025-09-24 19:21:40.14+02	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	sloc_01K4SMAF7MT4EDYRTNSRREKBR7	scloc_01K4SMAFA1XHFMNAMFP3A2JA9Z	2025-09-10 12:56:39.745713+02	2025-09-10 12:56:39.745713+02	\N
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-09-10 12:56:37.648581+02	2025-09-10 12:56:37.673865+02
2	migrate-tax-region-provider.js	2025-09-10 12:56:37.678114+02	2025-09-10 12:56:37.687055+02
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	Europe	\N	fuset_01K4SMAF860FQFEE83DH7AT2GQ	2025-09-10 12:56:39.686+02	2025-09-10 12:56:39.686+02	\N
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01K4SMAF92VR74P1PZQMBSJ99B	Express házhozszállítás	flat	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	sp_01K4SMAF80CR0K571MCCSAN3MD	manual_manual	\N	\N	sotype_01K4SMAF924FT2E34QE7P7AH7E	2025-09-10 12:56:39.715+02	2025-09-24 19:21:13.688+02	\N
so_01K4SMAF92J71A6F72T1SPBYH2	Általános házhozszállítás	flat	serzo_01K4SMAF86H7EWXD2E26MWQ9DJ	sp_01K4SMAF80CR0K571MCCSAN3MD	manual_manual	\N	\N	sotype_01K4SMAF92JZJNFR7SB9MHXQJF	2025-09-10 12:56:39.715+02	2025-09-24 19:21:25.733+02	\N
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01K4SMAF92J71A6F72T1SPBYH2	pset_01K4SMAF9C5W7YGY7CT9371SEK	sops_01K4SMAF9VKEMVT7JCYTQR48ND	2025-09-10 12:56:39.739201+02	2025-09-10 12:56:39.739201+02	\N
so_01K4SMAF92VR74P1PZQMBSJ99B	pset_01K4SMAF9DVCMNTY4AWMD7NNTX	sops_01K4SMAF9VQE981G8ZSG3GP2EQ	2025-09-10 12:56:39.739201+02	2025-09-10 12:56:39.739201+02	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01K4SMAF92RAX1K7C5V3F2T1SN	is_return	eq	"false"	so_01K4SMAF92J71A6F72T1SPBYH2	2025-09-10 12:56:39.715+02	2025-09-10 12:56:39.715+02	\N
sorul_01K4SMAF9203N4EW67TTB0W4N8	is_return	eq	"false"	so_01K4SMAF92VR74P1PZQMBSJ99B	2025-09-10 12:56:39.715+02	2025-09-10 12:56:39.715+02	\N
sorul_01K4SMAF9230T9HBPVZY5GJMMW	enabled_in_store	eq	"false"	so_01K4SMAF92J71A6F72T1SPBYH2	2025-09-10 12:56:39.715+02	2025-09-24 19:20:55.986+02	\N
sorul_01K4SMAF92XH75YYGX7S4WSJXV	enabled_in_store	eq	"false"	so_01K4SMAF92VR74P1PZQMBSJ99B	2025-09-10 12:56:39.715+02	2025-09-24 19:21:13.688+02	\N
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01K4SMAF92JZJNFR7SB9MHXQJF	Standard	Ship in 2-3 days.	standard	2025-09-10 12:56:39.715+02	2025-09-10 12:56:39.715+02	\N
sotype_01K4SMAF924FT2E34QE7P7AH7E	Express	Ship in 24 hours.	express	2025-09-10 12:56:39.715+02	2025-09-10 12:56:39.715+02	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01K4SMAD94H21EMA9WAHSBY8ND	Default Shipping Profile	default	\N	2025-09-10 12:56:37.668+02	2025-09-10 12:56:37.668+02	\N
sp_01K4SMAF80CR0K571MCCSAN3MD	Default	default	\N	2025-09-10 12:56:39.68+02	2025-09-10 12:56:39.68+02	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01K4SMAF7MT4EDYRTNSRREKBR7	2025-09-10 12:56:39.668+02	2025-09-24 19:20:28.856+02	\N	Kolárovo Teherguminet	laddr_01K4SMAF7MWMW32FFA5K45Y6AZ	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01K4SMAF7MWMW32FFA5K45Y6AZ	2025-09-10 12:56:39.668+02	2025-09-24 19:20:28.843+02	\N	Hlavna 18			Kolárovo	sk			94603	\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01K4SMAF5B3YF350FR28C6RAVT	Teherguminet	sc_01K4SMAF4SC9JMW6MT8ZGB3HK9	reg_01K4SMAF6Q56P0DB7GRM9TBN94	sloc_01K4SMAF7MT4EDYRTNSRREKBR7	\N	2025-09-10 12:56:39.594859+02	2025-09-10 12:56:39.594859+02	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01K5YBP5TX8S7VMYTNP9RKDDP8	eur	t	store_01K4SMAF5B3YF350FR28C6RAVT	2025-09-24 19:17:40.057875+02	2025-09-24 19:17:40.057875+02	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2025-09-10 12:56:36.988+02	2025-09-10 12:56:36.988+02	\N
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01K4SWZ7WRQFFW17A1K48GTBWN	tp_system	sk	\N	\N	\N	2025-09-10 15:27:48.888+02	2025-09-10 15:27:48.888+02	user_01K4SMAHM26RJ5B6M2BJR13N3T	\N
txreg_01K4SWZRE41FB8AHZZ2PFTDEVN	tp_system	hu	\N	\N	\N	2025-09-10 15:28:05.828+02	2025-09-10 15:28:05.828+02	user_01K4SMAHM26RJ5B6M2BJR13N3T	\N
txreg_01K4SMAF7DMVEV6180BDQPHCQ0	\N	de	\N	\N	\N	2025-09-10 12:56:39.661+02	2025-09-10 22:04:53.102+02	\N	2025-09-10 22:04:53.102+02
txreg_01K4SMAF7D6KD7AY3K2DWKQFEC	\N	dk	\N	\N	\N	2025-09-10 12:56:39.661+02	2025-09-10 22:04:56.223+02	\N	2025-09-10 22:04:56.222+02
txreg_01K4SMAF7DZQP50GM4AXYGHV45	\N	es	\N	\N	\N	2025-09-10 12:56:39.661+02	2025-09-10 22:04:59.135+02	\N	2025-09-10 22:04:59.135+02
txreg_01K4SMAF7DXFCW15BTV58ET8VG	\N	fr	\N	\N	\N	2025-09-10 12:56:39.661+02	2025-09-10 22:05:01.83+02	\N	2025-09-10 22:05:01.83+02
txreg_01K4SMAF7DDS20YJ61C9KBG70W	\N	gb	\N	\N	\N	2025-09-10 12:56:39.661+02	2025-09-10 22:05:04.917+02	\N	2025-09-10 22:05:04.917+02
txreg_01K4SMAF7DX1A8YV27PF6E18K5	\N	it	\N	\N	\N	2025-09-10 12:56:39.661+02	2025-09-10 22:05:07.882+02	\N	2025-09-10 22:05:07.882+02
txreg_01K4SMAF7DWDETZ6TX8H5K32FX	\N	se	\N	\N	\N	2025-09-10 12:56:39.661+02	2025-09-10 22:05:10.843+02	\N	2025-09-10 22:05:10.842+02
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01K4SMAHM26RJ5B6M2BJR13N3T			admin@test.com	\N	\N	2025-09-10 12:56:42.114+02	2025-09-10 15:32:23.357+02	\N
user_01K5YBK28XT329S1J3QCKTPS0N	\N	\N	nagy.viktordp@gmail.com	\N	\N	2025-09-24 19:15:58.109+02	2025-09-24 19:15:58.109+02	\N
user_01K5YBMGJXCB1ZENM46NH9HP8C	\N	\N	admin@teherguminet.hu	\N	\N	2025-09-24 19:16:45.534+02	2025-09-24 19:16:45.534+02	\N
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: medusa
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 25, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 124, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.order_display_id_seq', 2, true);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 2, true);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: approval approval_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_pkey PRIMARY KEY (id);


--
-- Name: approval_settings approval_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.approval_settings
    ADD CONSTRAINT approval_settings_pkey PRIMARY KEY (id);


--
-- Name: approval_status approval_status_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.approval_status
    ADD CONSTRAINT approval_status_pkey PRIMARY KEY (id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_cart_approval_approval cart_cart_approval_approval_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_cart_approval_approval
    ADD CONSTRAINT cart_cart_approval_approval_pkey PRIMARY KEY (cart_id, approval_id);


--
-- Name: cart_cart_approval_approval_status cart_cart_approval_approval_status_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_cart_approval_approval_status
    ADD CONSTRAINT cart_cart_approval_approval_status_pkey PRIMARY KEY (cart_id, approval_status_id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: company_company_approval_approval_settings company_company_approval_approval_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.company_company_approval_approval_settings
    ADD CONSTRAINT company_company_approval_approval_settings_pkey PRIMARY KEY (company_id, approval_settings_id);


--
-- Name: company_company_cart_cart company_company_cart_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.company_company_cart_cart
    ADD CONSTRAINT company_company_cart_cart_pkey PRIMARY KEY (company_id, cart_id);


--
-- Name: company_company_customer_customer_group company_company_customer_customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.company_company_customer_customer_group
    ADD CONSTRAINT company_company_customer_customer_group_pkey PRIMARY KEY (company_id, customer_group_id);


--
-- Name: company_employee_customer_customer company_employee_customer_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.company_employee_customer_customer
    ADD CONSTRAINT company_employee_customer_customer_pkey PRIMARY KEY (employee_id, customer_id);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_order_company_company order_order_company_company_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_order_company_company
    ADD CONSTRAINT order_order_company_company_pkey PRIMARY KEY (order_id, company_id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: quote quote_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.quote
    ADD CONSTRAINT quote_pkey PRIMARY KEY (id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_approval_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_approval_deleted_at" ON public.approval USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_approval_id_6173ada0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_approval_id_6173ada0" ON public.cart_cart_approval_approval USING btree (approval_id);


--
-- Name: IDX_approval_settings_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_approval_settings_deleted_at" ON public.approval_settings USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_approval_settings_id_-30aa2176; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_approval_settings_id_-30aa2176" ON public.company_company_approval_approval_settings USING btree (approval_settings_id);


--
-- Name: IDX_approval_status_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_approval_status_deleted_at" ON public.approval_status USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_approval_status_id_ad9c2dc3; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_approval_status_id_ad9c2dc3" ON public.cart_cart_approval_approval_status USING btree (approval_status_id);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id);


--
-- Name: IDX_cart_id_6173ada0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_id_6173ada0" ON public.cart_cart_approval_approval USING btree (cart_id);


--
-- Name: IDX_cart_id_ad9c2dc3; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_id_ad9c2dc3" ON public.cart_cart_approval_approval_status USING btree (cart_id);


--
-- Name: IDX_cart_id_ec91d584; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_id_ec91d584" ON public.company_company_cart_cart USING btree (cart_id);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_company_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_company_deleted_at" ON public.company USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_company_id_-30aa2176; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_company_id_-30aa2176" ON public.company_company_approval_approval_settings USING btree (company_id);


--
-- Name: IDX_company_id_133374bc8; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_company_id_133374bc8" ON public.order_order_company_company USING btree (company_id);


--
-- Name: IDX_company_id_194bf6160; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_company_id_194bf6160" ON public.company_company_customer_customer_group USING btree (company_id);


--
-- Name: IDX_company_id_ec91d584; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_company_id_ec91d584" ON public.company_company_cart_cart USING btree (company_id);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_id_194bf6160; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_group_id_194bf6160" ON public.company_company_customer_customer_group USING btree (customer_group_id);


--
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id);


--
-- Name: IDX_customer_id_a0a7245d; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_customer_id_a0a7245d" ON public.company_employee_customer_customer USING btree (customer_id);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-30aa2176; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-30aa2176" ON public.company_company_approval_approval_settings USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_133374bc8; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_133374bc8" ON public.order_order_company_company USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_194bf6160; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_194bf6160" ON public.company_company_customer_customer_group USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_6173ada0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_6173ada0" ON public.cart_cart_approval_approval USING btree (deleted_at);


--
-- Name: IDX_deleted_at_a0a7245d; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_a0a7245d" ON public.company_employee_customer_customer USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ad9c2dc3; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_ad9c2dc3" ON public.cart_cart_approval_approval_status USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ec91d584; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_ec91d584" ON public.company_company_cart_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_employee_company_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_employee_company_id" ON public.employee USING btree (company_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_employee_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_employee_deleted_at" ON public.employee USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_employee_id_a0a7245d; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_employee_id_a0a7245d" ON public.company_employee_customer_customer USING btree (employee_id);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-30aa2176; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-30aa2176" ON public.company_company_approval_approval_settings USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_133374bc8; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_133374bc8" ON public.order_order_company_company USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_194bf6160; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_194bf6160" ON public.company_company_customer_customer_group USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_6173ada0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_6173ada0" ON public.cart_cart_approval_approval USING btree (id);


--
-- Name: IDX_id_a0a7245d; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_a0a7245d" ON public.company_employee_customer_customer USING btree (id);


--
-- Name: IDX_id_ad9c2dc3; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_ad9c2dc3" ON public.cart_cart_approval_approval_status USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_ec91d584; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_ec91d584" ON public.company_company_cart_cart USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.cart_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_message_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_message_deleted_at" ON public.message USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_message_quote_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_message_quote_id" ON public.message USING btree (quote_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id);


--
-- Name: IDX_order_id_133374bc8; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_id_133374bc8" ON public.order_order_company_company USING btree (order_id);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id);


--
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id);


--
-- Name: IDX_quote_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_quote_deleted_at" ON public.quote USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: medusa
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: medusa
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employee employee_company_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.company(id) ON UPDATE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: message message_quote_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_quote_id_foreign FOREIGN KEY (quote_id) REFERENCES public.quote(id) ON UPDATE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict 72IOhpm30jeKShptTYhbx0I3ZZFBq96tyzQDLDBb7cgnVCKqM6dwdgbgc3o7hwh

