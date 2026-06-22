module dexlyn_tokenomics::dxlyn_coin {
    use supra_framework::fungible_asset::Metadata;
    use supra_framework::object::Object;

    // -----------------------------------------------------------------------------
    //                                STATES
    // -----------------------------------------------------------------------------

    /// DXLYN legacy coin type
    struct DXLYN {}

    // -----------------------------------------------------------------------------
    //                                ENTRY FUNCTIONS
    // -----------------------------------------------------------------------------

    /// Migrate dxlyn coin to fungible asset
    ///
    /// # Arguments
    /// * `user` - The signer of the transaction, representing the user migrating their coin store.
    native public fun migrate_to_fungible_asset(user: &signer);

    /// Transfer dxlyn token
    ///
    /// # Arguments
    /// * `account` - The signer of the transaction, representing the account from which the tokens will be transferred.
    /// * `to` - The address to which the tokens will be transferred.
    /// * `amount` - The amount of dxlyn tokens to transfer.
    native public fun transfer(account: &signer, to: address, amount: u64);

    /// Transfer dxlyn token to multiple recipients
    ///
    /// # Arguments
    /// * `sender` - The signer of the transaction, representing the sender of the dxlyn token.
    /// * `recipents` - The vector of addresses to which the tokens will be transferred.
    /// * `amounts` - The vector of amounts of dxlyn tokens to transfer.
    native public fun bluk_fa_transfer(sender: &signer, recipents: vector<address>, amounts: vector<u64>);


    // -----------------------------------------------------------------------------
    //                                VIEW FUNCTIONS
    // -----------------------------------------------------------------------------

    /// Get the dxlyn coin balance of a user
    ///
    /// # Arguments
    /// * `user_addr` - The address of the user whose dxlyn balance is to be retrieved.
    ///
    /// # Returns
    /// * The balance of dxlyn tokens held by the user.
    native public fun balance_of(user_addr: address): u64;

    /// Get the dxlyn coin total supply
    ///
    /// # Returns
    /// * The total supply of dxlyn tokens.
    native public fun total_supply(): u128;

    /// Get dxlyn asset metadata
    ///
    /// # Returns
    /// * The metadata object of the dxlyn asset.
    native public fun get_dxlyn_asset_metadata(): Object<Metadata>;

    /// Get dxlyn asset address
    ///
    /// # Returns
    /// * The address of the dxlyn asset.
    native public fun get_dxlyn_asset_address(): address;

    /// Get dxlyn object address
    ///
    /// # Returns
    /// * The address of the dxlyn object account.
    native public fun get_dxlyn_object_address(): address;
}
