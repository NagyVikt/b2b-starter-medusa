"use client"

import { setShippingAddress, updateCart } from "@/lib/data/cart"
import ErrorMessage from "@/modules/checkout/components/error-message"
import ShippingAddressForm from "@/modules/checkout/components/shipping-address-form"
import { SubmitButton } from "@/modules/checkout/components/submit-button"
import Divider from "@/modules/common/components/divider"
import CheckboxWithLabel from "@/modules/common/components/checkbox"
import Spinner from "@/modules/common/icons/spinner"
import { B2BCart, B2BCustomer } from "@/types"
import { ApprovalStatusType } from "@/types/approval"
import { CheckCircleSolid } from "@medusajs/icons"
import { Container, Heading, Text } from "@medusajs/ui"
import { usePathname, useRouter, useSearchParams } from "next/navigation"
import { useCallback, useState } from "react"

const ShippingAddress = ({
  cart,
  customer,
}: {
  cart: B2BCart | null
  customer: B2BCustomer | null
}) => {
  const searchParams = useSearchParams()
  const router = useRouter()
  const pathname = usePathname()
  const [error, setError] = useState<string | null>(null)
  const [billingSameAsShipping, setBillingSameAsShipping] = useState(true)

  const isOpen = searchParams.get("step") === "shipping-address"

  const cartApprovalStatus = cart?.approval_status?.status

  const createQueryString = useCallback(
    (name: string, value: string) => {
      const params = new URLSearchParams(searchParams)
      params.set(name, value)

      return params.toString()
    },
    [searchParams]
  )
  const handleEdit = () => {
    router.push(
      pathname + "?" + createQueryString("step", "shipping-address"),
      { scroll: false }
    )
  }

  const handleSubmit = async (formData: FormData) => {
    await setShippingAddress(formData).catch((e) => {
      setError(e.message)
      return
    })

    if (billingSameAsShipping) {
      const billing_address = {
        first_name: formData.get("shipping_address.first_name")?.toString() || "",
        last_name: formData.get("shipping_address.last_name")?.toString() || "",
        address_1: formData.get("shipping_address.address_1")?.toString() || "",
        company: formData.get("shipping_address.company")?.toString() || "",
        postal_code: formData.get("shipping_address.postal_code")?.toString() || "",
        city: formData.get("shipping_address.city")?.toString() || "",
        country_code: formData.get("shipping_address.country_code")?.toString() || "",
        province: formData.get("shipping_address.province")?.toString() || "",
        phone: formData.get("shipping_address.phone")?.toString() || "",
      } as any
      await updateCart({ billing_address })
      router.push(pathname + "?step=delivery", { scroll: false })
      return
    }

    router.push(pathname + "?" + createQueryString("step", "billing-address"), {
      scroll: false,
    })
  }

  return (
    <Container>
      <div className="flex flex-col gap-y-2">
        <div className="flex flex-row items-center justify-between w-full">
          <Heading
            level="h2"
            className="flex flex-row text-xl gap-x-2 items-center"
          >
            Szállítási cím
            {!isOpen && cart?.shipping_address?.address_1 ? (
              <CheckCircleSolid className="text-green-600" />
            ) : null}
          </Heading>

          {!isOpen && cart?.shipping_address?.address_1 && (
              <Text>
                <button
                  onClick={handleEdit}
                  className="text-ui-fg-interactive hover:text-ui-fg-interactive-hover"
                  data-testid="edit-address-button"
                >
                  Szerkesztés
                </button>
              </Text>
            )}
        </div>
        <Divider />
        {isOpen ? (
          <form action={handleSubmit}>
            <div className="pb-8">
              <ShippingAddressForm customer={customer} cart={cart} />
              <div className="flex flex-col gap-y-2 items-end">
                <div className="w-full">
                  <div className="flex items-center justify-between rounded-xl bg-white border border-neutral-200 px-4 py-3">
                    <CheckboxWithLabel
                      label="Számlázási cím megegyezik a szállítási címmel"
                      name="same_as_shipping_for_billing"
                      checked={billingSameAsShipping}
                      onChange={() => setBillingSameAsShipping((v) => !v)}
                    />
                  </div>
                </div>
                <SubmitButton
                  className="mt-6"
                  data-testid="submit-address-button"
                >
                  Következő lépés
                </SubmitButton>
                <ErrorMessage
                  error={error}
                  data-testid="address-error-message"
                />
              </div>
            </div>
          </form>
        ) : cart && cart.shipping_address?.address_1 ? (
          <div className="text-small-regular">
            <div className="flex items-start gap-x-8">
              <div className="flex" data-testid="shipping-address-summary">
                <Text className="txt-medium text-ui-fg-subtle">
                  {cart.shipping_address.first_name}{" "}
                  {cart.shipping_address.last_name},{" "}
                  {cart.shipping_address.address_1},{" "}
                  {cart.shipping_address.postal_code},{" "}
                  {cart.shipping_address.city},{" "}
                  {cart.shipping_address.country_code?.toUpperCase()}
                </Text>
              </div>
            </div>
          </div>
        ) : null}
      </div>
    </Container>
  )
}

export default ShippingAddress
