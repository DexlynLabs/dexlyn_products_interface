module dexlyn_aggregator::dexlyn_agg_swap {
    use std::option;
    /// Public entry that withdraws the user's input (coin or fungible asset), routes the
    /// swap across up to 15 splits and up to 3 hops per split, then deposits any unspent
    /// input back to the user and the output to the recipient.
    /// Params
    /// - user_signer: signer of the swap initiator (input funds are withdrawn from here).
    /// - recipient_address: receiver of the output; must not be `@0x0`.
    /// - swap_mode: 1 = SWAP_MODE_EXACT_INPUT, 2 = SWAP_MODE_EXACT_OUTPUT.
    /// - split_count: number of parallel split paths (1..=15).
    /// - step_counts: number of hops per split (1..=3 each).
    /// - dex_types: per split / per step / per pool identifier of the target DEX family.
    /// - pool_ids: per split / per step / per pool numeric pool identifier (DEX-specific).
    /// - is_x_to_y: per split / per step / per pool trade direction within the pool.
    /// - pool_types: per split / per step pool kind (FA_TO_FA, FA_TO_COIN, ...).
    /// - token_addresses: per split / per step / per pool token addresses the step touches.
    /// - token_x_addresses: per split / per step first-token address (input side of the hop).
    /// - token_y_addresses: per split / per step second-token address (output side of the hop).
    /// - extra_data: optional per split / per step / per pool / per field raw payload for DEX-specific args.
    /// - step_amounts: per split / per step / per pool amounts (split shares or limits).
    /// - extradex_types: optional auxiliary DEX-type vector used by some routing variants.
    /// - output_token_address: address of the expected output asset.
    /// - split_amounts: input amount allocated to each split; total == withdrawn input.
    /// - min_output_amount: minimum acceptable total output amount (slippage floor).
    /// - fee_basis_points: integrator fee in basis points (1/10000).
    /// - integrator_address: account receiving the integrator fee share.
    /// Return
    native public fun aggregated_swap_entry<
        InputTokenType, Coin1, Coin2, Coin3, Coin4, Coin5,
        Coin6, Coin7, Coin8, Coin9, Coin10,
        Coin11, Coin12, Coin13, Coin14, Coin15,
        Coin16, Coin17, Coin18, Coin19, Coin20,
        Coin21, Coin22, Coin23, Coin24, Coin25,
        Coin26, Coin27, Coin28, Coin29, Coin30,
        OutputTokenType
    >(
        user_signer: &signer,
        recipient_address: address,
        swap_mode: u64,
        split_count: u8,
        step_counts: vector<u8>,
        dex_types: vector<vector<vector<u8>>>,
        pool_ids: vector<vector<vector<u64>>>,
        is_x_to_y: vector<vector<vector<bool>>>,
        pool_types: vector<vector<u8>>,
        token_addresses: vector<vector<vector<address>>>,
        token_x_addresses: vector<vector<address>>,
        token_y_addresses: vector<vector<address>>,
        extra_data: option::Option<vector<vector<vector<vector<vector<u8>>>>>>,
        step_amounts: vector<vector<vector<u64>>>,
        extradex_types: option::Option<vector<vector<vector<u8>>>>,
        output_token_address: address,
        split_amounts: vector<u64>,
        min_output_amount: u64,
        fee_basis_points: u64,
        integrator_address: address
    );
}