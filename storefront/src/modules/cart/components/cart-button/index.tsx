import { CartProvider } from "@/lib/context/cart-context"
import CartDrawer from "@/modules/cart/components/cart-drawer"
import { B2BCart, B2BCustomer } from "@/types/global"
import { StoreFreeShippingPrice } from "@/types/shipping-option/http"

type CartButtonProps = {
  cart: B2BCart | null
  customer: B2BCustomer | null
  freeShippingPrices: StoreFreeShippingPrice[]
}

export default function CartButton({
  cart,
  customer,
  freeShippingPrices,
}: CartButtonProps) {
  return (
    <CartProvider cart={cart}>
      <CartDrawer customer={customer} freeShippingPrices={freeShippingPrices} />
    </CartProvider>
  )
}
