module supra_names::v2_1_domains {
    use supra_framework::supra_coin::SupraCoin;
    use supra_framework::coin::{Coin};
    use supra_framework::event;
    use supra_framework::object::{ExtendRef, TransferRef};
    use std::option::{Option};
    use std::string::{String};

    const APP_OBJECT_SEED: vector<u8> = b"SNS";
    const COLLECTION_DESCRIPTION: vector<u8> = b".supra names from Supra";
    const SUBDOMAIN_COLLECTION_DESCRIPTION: vector<u8> = b"subdomain of .supra names from Supra ";
    const COLLECTION_URI: vector<u8> = b"https://suprans.id";
    /// current MAX_REMAINING_TIME_FOR_RENEWAL_SEC is 6 months
    const MAX_REMAINING_TIME_FOR_RENEWAL_SEC: u64 = 15552000;
    const SECONDS_PER_YEAR: u64 = 60 * 60 * 24 * 365;

    /// enums for subdomain expiration policy. update validate_subdomain_expiration_policy() when adding more
    const SUBDOMAIN_POLICY_MANUAL_SET_EXPIRATION: u8 = 0;
    const SUBDOMAIN_POLICY_LOOKUP_DOMAIN_EXPIRATION: u8 = 1;
    // const SUBDOMAIN_POLICY_NEXT_ENUM = 2

    /// The Naming Service contract is not enabled
    const ENOT_ENABLED: u64 = 1;
    /// The caller is not authorized to perform this operation
    const ENOT_AUTHORIZED: u64 = 2;
    /// The name is not available, as it has already been registered
    const ENAME_NOT_AVAILABLE: u64 = 3;
    /// The number of years the caller attempted to register the domain or subdomain for is invalid
    const EINVALID_NUMBER_YEARS: u64 = 4;
    /// The domain does not exist- it is not registered
    const ENAME_NOT_EXIST: u64 = 5;
    /// The caller is not the owner of the domain, and is not authorized to perform the action
    const ENOT_OWNER_OF_DOMAIN: u64 = 6;
    /// The caller is not the owner of the name, and is not authorized to perform the action
    const ENOT_OWNER_OF_NAME: u64 = 9;
    /// The domain name is too long- it exceeds the configured maximum number of utf8 glyphs
    const ENAME_TOO_LONG: u64 = 10;
    /// The domain is too short.
    const ENAME_TOO_SHORT: u64 = 11;
    /// The domain name contains invalid characters: it is not a valid domain name
    const ENAME_HAS_INVALID_CHARACTERS: u64 = 12;
    /// The required `register_domain_signature` for `register_domain` is missing
    const EVALID_SIGNATURE_REQUIRED: u64 = 16;
    /// The name is not expired in 6 months, thus not eligible for renewal
    const EDOMAIN_NOT_AVAILABLE_TO_RENEW: u64 = 18;
    /// The subdomain is not eligible for renewal
    const ESUBDOMAIN_IS_AUTO_RENEW: u64 = 19;
    /// The name is expired
    const ENAME_EXPIRED: u64 = 20;
    /// The subdomain not exist
    const ESUBDOMAIN_NOT_EXIST: u64 = 21;
    /// The name is not a subdomain
    const ENOT_A_SUBDOMAIN: u64 = 22;
    /// The subdomain expiration can be set any date before the domain expiration
    const ESUBDOMAIN_EXPIRATION_PASS_DOMAIN_EXPIRATION: u64 = 24;
    /// The duration must be whole years
    const EDURATION_MUST_BE_GREATER_THAN_ONE_YEAR: u64 = 25;
    /// The subdomain expiration policy is included in the enum SUBDOMAIN_POLICY_*
    const ESUBDOMAIN_EXPIRATION_POLICY_INVALID: u64 = 26;
    /// Caller must be the router
    const ENOT_ROUTER: u64 = 27;
    /// Cannot register subdomain while its domain has expired
    const ECANNOT_REGISTER_SUBDOMAIN_WHILE_DOMAIN_HAS_EXPIRED: u64 = 28;
    /// Cannot transfer subdomain while its domain has expired
    const ECANNOT_TRANSFER_SUBDOMAIN_WHILE_DOMAIN_HAS_EXPIRED: u64 = 29;
    /// The domain is expired
    const EDOMAIN_EXPIRED: u64 = 30;
    /// Name is expired and out of grace period
    const ECANNOT_RENEW_NAME_THAT_IS_EXPIRED_AND_PAST_GRACE_PERIOD: u64 = 31;

    const EALREADY_INITIALIZED: u64 = 32;

    const EAMOUNT_ZERO: u64 = 33;

    #[resource_group(scope = global)]
    struct ObjectGroup { }

    /// Tokens require a signer to create and we want to store global resources. We use object to achieve both
    struct DomainObject has key {
        extend_ref: ExtendRef,
    }

    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    struct NameRecord has key {
        domain_name: String,
        expiration_time_sec: u64,
        target_address: Option<address>,
        transfer_ref: TransferRef,
        registration_time_sec: u64,
        // Currently unused, but may be used in the future to extend with more metadata
        extend_ref: ExtendRef,
    }

    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    /// This is a subdomain extension that is only used for subdomains
    struct SubdomainExt has key {
        subdomain_name: String,
        subdomain_expiration_policy: u8,
    }

    struct ReverseRecord has key {
        token_addr: Option<address>,
    }

    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    /// Holder for `SetReverseLookupEvent` events
    struct SetReverseLookupEvents has key {
        set_reverse_lookup_events: event::EventHandle<SetReverseLookupEvent>,
    }

    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    /// Holder for `SetTargetAddressEvent` events
    struct SetTargetAddressEvents has key {
        set_name_events: event::EventHandle<SetTargetAddressEvent>,
    }

    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    /// Holder for `RegisterNameEvent` events
    struct RegisterNameEvents has key {
        register_name_events: event::EventHandle<RegisterNameEvent>,
    }

    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    /// Holder for `RenewNameEvent` events
    struct RenewNameEvents has key {
        renew_name_events: event::EventHandle<RenewNameEvent>,
    }

    /// A name has been set as the reverse lookup for an address, or
    /// the reverse lookup has been cleared (in which case |target_address|
    /// will be none)
    struct SetReverseLookupEvent has drop, store {
        /// The address this reverse lookup belongs to
        account_addr: address,

        /// Indexer needs knowledge of previous state
        prev_domain_name: Option<String>,
        prev_subdomain_name: Option<String>,
        prev_expiration_time_secs: Option<u64>,

        curr_domain_name: Option<String>,
        curr_subdomain_name: Option<String>,
        curr_expiration_time_secs: Option<u64>,
    }

    /// A name (potentially subdomain) has had it's address changed
    /// This could be to a new address, or it could have been cleared
    struct SetTargetAddressEvent has drop, store {
        domain_name: String,
        subdomain_name: Option<String>,
        expiration_time_secs: u64,
        new_address: Option<address>,
    }

    /// A name (potentially subdomain) has been registered on chain
    /// Includes the the fee paid for the registration, and the expiration time
    struct RegisterNameEvent has drop, store {
        domain_name: String,
        subdomain_name: Option<String>,
        registration_fee_octas: u64,
        expiration_time_secs: u64,
    }

    /// A name (potentially subdomain) has been renewed on chain
    /// Includes the the fee paid for the registration, and the expiration time
    struct RenewNameEvent has drop, store {
        domain_name: String,
        subdomain_name: Option<String>,
        renewal_fee_octas: u64,
        expiration_time_secs: u64,

        // Extras for indexing
        target_address: Option<address>,
        is_primary_name: bool,
    }

    /// Escrows protocol fees until the fee collector pulls them
    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    struct ProtocolFees has key {
        fees: Coin<SupraCoin>,
    }

    // === REGISTER NAME ===

    /// A wrapper around `register_name` as an  function.
    /// Option<String> is not currently serializable, so we have these convenience methods
    public native fun register_domain(
        router_signer: &signer,
        sign: &signer,
        domain_name: String,
        registration_duration_secs: u64,
    ) ;

    /// A wrapper around `register_name` as an  function.
    /// Option<String> is not currently serializable, so we have these convenience method
    /// `expiration_time_sec` is the timestamp, in seconds, when the name expires
    public native fun register_subdomain(
        router_signer: &signer,
        sign: &signer,
        domain_name: String,
        subdomain_name: String,
        registration_duration_secs: u64
    ) ;

    /// Router-only registration that does not take registration fees. Should only be used for v1=>v2 migrations.
    /// We skip checking registration duration because it is not necessarily a whole number year
    public native fun register_name_with_router(
        router_signer: &signer,
        sign: &signer,
        domain_name: String,
        subdomain_name: Option<String>,
        registration_duration_secs: u64,
    ) ;

    // === RENEW DOMAIN ===

    public native fun renew_domain(
        sign: &signer,
        domain_name: String,
        renewal_duration_secs: u64,
    ) ;

    // === SUBDOMAIN MANAGEMENT ===

    /// Disable or enable subdomain owner from transferring subdomain as domain owner
    public native fun set_subdomain_transferability_as_domain_owner(
        router_signer: &signer,
        sign: &signer,
        domain_name: String,
        subdomain_name: String,
        transferrable: bool
    ) ;

    public native fun transfer_subdomain_owner(
        sign: &signer,
        domain_name: String,
        subdomain_name: String,
        new_owner_address: address,
        new_target_address: Option<address>,
    ) ;

    /// this is for domain owner to update subdomain expiration time
    public native fun set_subdomain_expiration(
        domain_admin: &signer,
        domain_name: String,
        subdomain_name: String,
        expiration_time_sec: u64,
    ) ;

    public native fun set_subdomain_expiration_policy(
        domain_admin: &signer,
        domain_name: String,
        subdomain_name: String,
        subdomain_expiration_policy: u8,
    ) ;

    public native fun get_subdomain_renewal_policy(
        domain_name: String,
        subdomain_name: String,
    ): u8 ;

    // === TARGET ADDRESS FUNCTIONS ===

    public native fun set_target_address(
        sign: &signer,
        domain_name: String,
        subdomain_name: Option<String>,
        new_address: address
    ) ;

    /// This is a shared  point for clearing the address of a domain or subdomain
    /// It enforces owner permissions
    public native fun clear_target_address(
        sign: &signer,
        subdomain_name: Option<String>,
        domain_name: String
    ) ;

    // === PRIMARY NAMES ===

    /// Sets the |account|'s reverse lookup, aka "primary name". This allows a user to specify which of their Supra Names
    /// is their "primary", so that dapps can display the user's primary name rather than their address.
    public  native fun set_reverse_lookup(
        account: &signer,
        subdomain_name: Option<String>,
        domain_name: String
    ) ;

    /// Clears the user's reverse lookup.
    public native fun clear_reverse_lookup(
        account: &signer
    ) ;

    /// Returns the reverse lookup (the token addr) for an address if any.
    public native fun get_reverse_lookup(
        account_addr: address
    ): Option<address> ;

    /// Returns whether a ReverseRecord exists at `account_addr`
    public native fun reverse_record_exists(account_addr: address): bool;
// === FORCE FUNCTIONS VIA GOVERNANCE ===

    /// Forcefully set the name of a domain.
    /// This is a privileged operation, used via governance, to forcefully set a domain address
    /// This can be used, for example, to forcefully set the domain for a system address domain
    public  native fun force_set_target_address(
        sign: &signer,
        domain_name: String,
        subdomain_name: Option<String>,
        new_owner: address
    ) ;

    /// Forcefully create or seize a domain name. This is a privileged operation, used via governance.
    /// This can be used, for example, to forcefully create a domain for a system address domain, or to seize a domain from a malicious user.
    /// The `registration_duration_secs` parameter is the number of seconds to register the domain for, but is not limited to the maximum set in the config for domains registered normally.
    /// This allows, for example, to create a domain for the system address for 100 years so we don't need to worry about expiry
    /// Or for moderation purposes, it allows us to seize a racist/harassing domain for 100 years, and park it somewhere safe
    public  native fun force_create_or_seize_name(
        sign: &signer,
        domain_name: String,
        subdomain_name: Option<String>,
        registration_duration_secs: u64
    ) ;

    /// This removes a name mapping from the registry; functionally this 'expires' it.
    /// This is a privileged operation, used via governance.
    public  native fun force_clear_registration(
        sign: &signer,
        domain_name: String,
        subdomain_name: Option<String>,
    ) ;

    public  native fun force_set_name_expiration(
        sign: &signer,
        domain_name: String,
        subdomain_name: Option<String>,
        new_expiration_secs: u64
    ) ;


    // === HELPER FUNCTIONS ===

    public native fun is_domain_in_renewal_window(
        domain_name: String,
    ): bool ;

    public native fun get_app_signer_addr(): address;

    public native fun get_token_addr(
        domain_name: String,
        subdomain_name: Option<String>,
    ): address;

    /// Checks for the name not existing, or being expired
    /// Returns true if the name is available for registration
    /// if this is a subdomain, and the domain doesn't exist, returns false
    /// Doesn't use the `name_is_expired` or `name_is_registered` internally to share the borrow
    public native fun is_name_registerable(
        domain_name: String,
        subdomain_name: Option<String>,
    ): bool ;

    /// Returns true if
    /// 1. The name is not registered OR
    /// 2. The name is a subdomain AND subdomain was registered before the domain OR
    /// 3. The name is registered AND is expired and past grace period
    public native fun is_name_expired_past_grace(
        domain_name: String,
        subdomain_name: Option<String>,
    ): bool ;

    /// Returns true if
    /// 1. The name is not registered OR
    /// 2. The name is a subdomain AND subdomain was registered before the domain OR
    /// 3. The name is registered AND is expired
    public native fun is_name_expired(
        domain_name: String,
        subdomain_name: Option<String>,
    ): bool ;

    /// Returns true if the object exists AND the owner is not the `token_resource` account
    public native fun is_name_registered(
        domain_name: String,
        subdomain_name: Option<String>,
    ): bool;

    /// Check if the address is the owner of the given supra_name
    /// If the name does not exist returns false
    public native fun is_token_owner(
        owner_addr: address,
        domain_name: String,
        subdomain_name: Option<String>,
    ): bool;

    /// Returns a name's owner address. Returns option::none() if there is no owner.
    public native fun get_name_owner_addr(
        subdomain_name: Option<String>,
        domain_name: String,
    ): Option<address> ;

    public native fun get_expiration(
        domain_name: String,
        subdomain_name: Option<String>,
    ): u64 ;

    public native fun get_target_address(
        domain_name: String,
        subdomain_name: Option<String>,
    ): Option<address> ;

    public native fun get_name_props_from_token_addr(
        token_addr: address
    ): (Option<String>, String) ;

    /// Given a time, returns true if that time is in the past, false otherwise
    public native fun is_time_expired(expiration_time_sec: u64): bool;

    // ==== Dexlyn Fee Collection ====

    public  native fun initialize_protocol_fees(signer: &signer);

    #[view]
    public native fun get_accumulated_protocol_fees(): u64 ;

    public  native fun collect_protocol_fees(fee_collection_admin: &signer) ;

}