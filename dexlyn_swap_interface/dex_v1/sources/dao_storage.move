module dexlyn_swap::dao_storage {


    use supra_framework::coin::{Coin};

    /// Defined Storage seed that are used for creating object
    const SEED_DAO_STORAGE: vector<u8> = b"dao_storage::Storage";

    #[resource_group_member(group = supra_framework::object::ObjectGroup)]
    /// Storage for keeping coins
    struct Storage<phantom X, phantom Y, phantom Curve> has key {
        coin_x: Coin<X>,
        coin_y: Coin<Y>
    }

    /// Withdraw coins from storage
    /// Parameters:
    /// * `dao_admin_acc` - DAO admin
    /// * `pool_addr` - pool owner address
    /// * `x_val` - amount of X coins to withdraw
    /// * `y_val` - amount of Y coins to withdraw
    /// Returns both withdrawn X and Y coins: `(Coin<X>, Coin<Y>)`.
    public native fun withdraw<X, Y, Curve>(
        dao_admin_acc: &signer,
        lp_pool_object_addr: address,
        x_val: u64,
        y_val: u64
    ): (Coin<X>, Coin<Y>);

    #[view]
    public native fun get_accrued_dao_fee<X, Y, Curve>(lp_pool_object_addr: address): (u64, u64) ;


    /// Collects all accrued protocol (DAO) fees for a single pool and returns them to the caller.
    /// Returns both collected X and Y coins: `(Coin<X>, Coin<Y>)`.
    public native fun collect_protocol_fees_by_collector<X, Y, Curve>(
        collector: &signer,
        lp_pool_object_addr: address,
    ): (Coin<X>, Coin<Y>) ;



}