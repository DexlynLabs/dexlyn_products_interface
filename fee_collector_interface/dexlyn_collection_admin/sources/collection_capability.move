/// Shared capability for epoch fee collection. Used by protocols and `dexlyn_fees_collector`.
module dexlyn_collection_admin::collection_capability {

    const E_CAPABILITY_MISSING: u64 = 1;
    const E_NOT_FEE_COLLECTOR_ADMIN: u64 = 2;

    struct CollectionCapability has key {}

    /// Install on collection admin (`@dexlyn_fees_collector` package signer only).
    native public fun issue_to(admin: &signer, package_signer: &signer);

    /// Install on collection admin (`@dexlyn_fees_collector` package signer only).
    native public entry fun revoke_from(admin: &signer, package_address: address);

    native public fun check_collection_capability(account: &signer);

    #[view]
    public fun exists_at(addr: address): bool;
}
