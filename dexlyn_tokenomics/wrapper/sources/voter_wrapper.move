module dexlyn_tokenomics_wrapper::voter_wrapper {
    /// Collect accumulated protocol fees. Admin only.
    ///
    /// # Arguments
    /// * `fee_collection_admin` - The signer with fee collection capability.
    native public fun collect_protocol_fees(fee_collection_admin: &signer);

    /// Get the total accumulated protocol fees
    ///
    /// # Returns
    /// * The total amount of accumulated protocol fees in DXLYN.
    native public fun get_accumulated_protocol_fees(): u64;
}
