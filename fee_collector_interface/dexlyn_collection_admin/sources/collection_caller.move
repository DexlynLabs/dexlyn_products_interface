/// `assert_collection_caller` for CLMM and other protocols (no `dexlyn_fees_collector` dependency).
module dexlyn_fees_collector_admin::collection_caller {
    native public fun set_collection_bot(admin: &signer, collection_bot: address);

    #[view]
    native public fun get_collection_bots(): vector<address>;

    native public fun assert_collection_caller(collection_bot: &signer);

}
