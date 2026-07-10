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

    /// The protocol fees accumulated in a pool.
    struct ProtocolFeesView has drop {
        lp_pool_object_addr: address,
        amount_a: u64,
        amount_b: u64,
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
    >(lp_pool_object_addr: vector<address>): vector<ProtocolFeesView> ;

    /// Destructures a `ProtocolFeesView` into `(lp_pool_object_addr, amount_a, amount_b)`.
    public native fun destructure_pool_protocol_fees(fees: &ProtocolFeesView): (address, u64, u64);

    /// Collects all accrued protocol (DAO) fees for a single pool and returns them to the caller.
    /// Returns both collected X and Y coins: `(Coin<X>, Coin<Y>)`.
    public native fun collect_protocol_fees_by_collector<X, Y, Curve>(
        collector: &signer,
        lp_pool_object_addr: address,
    ): (Coin<X>, Coin<Y>) ;

    /// Reads the accrued protocol fees `(x, y)` held by a single pool storage.
    native fun accrued_fee_of<X, Y, Curve>(lp_pool_object_addr: address): (u64, u64) ;


}