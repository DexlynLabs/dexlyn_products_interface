module dexlyn::managed_fee_distributor {

    /// Collect accumulated protocol fees for a specific asset. Admin only.
    ///
    /// # Arguments
    /// * `fee_collection_admin` - The signer with fee collection capability.
    native public fun collect_protocol_fees<AssetT>(fee_collection_admin: &signer);

    /// Get the total accumulated protocol fees for a specific asset.
    ///
    /// # Returns
    /// * The total amount of accumulated protocol fees in the specified asset.
    native public fun get_accumulated_protocol_fees<AssetT>(): u64;

}