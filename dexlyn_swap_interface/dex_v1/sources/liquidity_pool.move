module dexlyn_swap::liquidity_pool {

    #[view]
    native public fun generate_lp_object_address<X, Y, Curve>(): address ;
}
