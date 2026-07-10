/// The current module contains pre-deplopyed scripts for dexlyn_swap.
module dexlyn_swap::scripts {

    use aptos_std::type_info::TypeInfo;

    /// The protocol fees accumulated in a pool.
    struct ProtocolFeesView has copy, drop {
        coin_type_x: TypeInfo,
        coin_type_y: TypeInfo,
        coin_type_curve: TypeInfo,
        lp_pool_object_addr: address,
        amount_a: u64,
        amount_b: u64,
    }

    /// Register a new liquidity pool for `X`/`Y` pair.
    ///
    /// Note: X, Y generic coin parameters must be sorted.
    public native fun register_pool<X, Y, Curve>(account: &signer);

    /// Register a new liquidity pool `X`/`Y` and immediately add liquidity.
    /// * `coin_x_val` - amount of coin `X` to add as liquidity.
    /// * `coin_x_val_min` - minimum amount of coin `X` to add as liquidity (slippage).
    /// * `coin_y_val` - minimum amount of coin `Y` to add as liquidity.
    /// * `coin_y_val_min` - minimum amount of coin `Y` to add as liquidity (slippage).
    ///
    /// Note: X, Y generic coin parameters must be sorted.
    public native fun register_pool_and_add_liquidity<X, Y, Curve>(
        account: &signer,
        coin_x_val: u64,
        coin_x_val_min: u64,
        coin_y_val: u64,
        coin_y_val_min: u64,
    );

    /// Add new liquidity into pool `X`/`Y` and get liquidity coin `LP`.
    /// * `coin_x_val` - amount of coin `X` to add as liquidity.
    /// * `coin_x_val_min` - minimum amount of coin `X` to add as liquidity (slippage).
    /// * `coin_y_val` - minimum amount of coin `Y` to add as liquidity.
    /// * `coin_y_val_min` - minimum amount of coin `Y` to add as liquidity (slippage).
    ///
    /// Note: X, Y generic coin parameters must be sorted.
    public native fun add_liquidity<X, Y, Curve>(
        account: &signer,
        coin_x_val: u64,
        coin_x_val_min: u64,
        coin_y_val: u64,
        coin_y_val_min: u64,
    );

    /// Remove (burn) liquidity coins `LP` from account, get `X` and`Y` coins back.
    /// * `lp_val` - amount of `LP` coins to burn.
    /// * `min_x_out_val` - minimum amount of X coins to get.
    /// * `min_y_out_val` - minimum amount of Y coins to get.
    ///
    /// Note: X, Y generic coin parameters must be sorted.
    public native fun remove_liquidity<X, Y, Curve>(
        account: &signer,
        lp_val: u64,
        min_x_out_val: u64,
        min_y_out_val: u64,
    );

    /// Swap exact coin `X` for at least minimum coin `Y`.
    /// * `coin_val` - amount of coins `X` to swap.
    /// * `coin_out_min_val` - minimum expected amount of coins `Y` to get.
    public native fun swap<X, Y, Curve>(
        account: &signer,
        coin_val: u64,
        coin_out_min_val: u64,
    );

    /// Swap maximum coin `X` for exact coin `Y`.
    /// * `coin_val_max` - how much of coins `X` can be used to get `Y` coin.
    /// * `coin_out` - how much of coins `Y` should be returned.
    public native fun swap_into<X, Y, Curve>(
        account: &signer,
        coin_val_max: u64,
        coin_out: u64,
    );

    /// Swap `coin_in` of X for a `coin_out` of Y.
    /// Does not check optimality of the swap, and fails if the `X` to `Y` price ratio cannot be satisfied.
    /// * `coin_in` - how much of coins `X` to swap.
    /// * `coin_out` - how much of coins `Y` should be returned.
    public native fun swap_unchecked<X, Y, Curve>(
        account: &signer,
        coin_in: u64,
        coin_out: u64,
    );

    /// To withdraw a part of the accrued DAO fees from the Liquidity Pool Object
    /// Only the Dao Admin can withdraw
    /// `x_val` and `y_val` are the amount of fees for each coin that is going to get withdraw
    public native fun withdraw_dao_fee<X, Y, Curve>(
        dao_admin: &signer,
        x_val: u64,
        y_val: u64,
    );

    /// To withdraw a part of the accrued DAO fees from the Liquidity Pool Object
    /// Only the Dao Admin can withdraw entire amount of fees for each coin that is accrueded so far
    public native fun withdraw_accrued_dao_fee<X, Y, Curve>(
        dao_admin: &signer,
    );

    /// Collects the accrued protocol (DAO) fees for up to 10 pools
    public native fun collect_protocol_fees_by_collector
    <X1, Y1, C1,
    X2, Y2, C2,
    X3, Y3, C3,
    X4, Y4, C4,
    X5, Y5, C5,
    X6, Y6, C6,
    X7, Y7, C7,
    X8, Y8, C8,
    X9, Y9, C9,
    X10, Y10, C10
    >(collector: &signer, pools_length: u8);

    #[view]
    // Returns the accrued protocol (DAO) fees for up to 10 pools
    public native fun get_accrued_protocol_fees
    <X1, Y1, C1,
     X2, Y2, C2,
     X3, Y3, C3,
     X4, Y4, C4,
     X5, Y5, C5,
     X6, Y6, C6,
     X7, Y7, C7,
     X8, Y8, C8,
     X9, Y9, C9,
     X10, Y10, C10
    >(pools_length: u8): vector<ProtocolFeesView> ;

    public fun destructure_pool_protocol_fees(fees: &ProtocolFeesView): (TypeInfo, TypeInfo, TypeInfo, address, u64, u64) {
        (fees.coin_type_x, fees.coin_type_y, fees.coin_type_curve, fees.lp_pool_object_addr, fees.amount_a, fees.amount_b)
    }
}