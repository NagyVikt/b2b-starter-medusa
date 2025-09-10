"use client"

import { setBillingAddress, updateCart } from "@/lib/data/cart"
import compareAddresses from "@/lib/util/compare-addresses"
import BillingAddressForm from "@/modules/checkout/components/billing-address-form"
import ErrorMessage from "@/modules/checkout/components/error-message"
import { SubmitButton } from "@/modules/checkout/components/submit-button"
import CheckboxWithLabel from "@/modules/common/components/checkbox"
import Divider from "@/modules/common/components/divider"
import { B2BCart } from "@/types"
import { ApprovalStatusType } from "@/types/approval"
import { CheckCircleSolid } from "@medusajs/icons"
import { clx, Container, Heading, Text } from "@medusajs/ui"
import { usePathname, useRouter, useSearchParams } from "next/navigation"
import { useCallback, useEffect, useState } from "react"

const BillingAddress = ({ cart }: { cart: B2BCart | null }) => {
  const searchParams = useSearchParams()
  const router = useRouter()
  const pathname = usePathname()

  const [error, setError] = useState<string | null>(null)

  const isOpen = searchParams.get("step") === "billing-address"

  const cartApprovalStatus = cart?.approval_status?.status

  const [sameAsBilling, setSameAsBilling] = useState<boolean>(() => {
    if (cart?.shipping_address) {
      if (!cart?.billing_address?.address_1) return true
      return compareAddresses(cart.shipping_address, cart.billing_address)
    }
    return false
  })

  const createQueryString = useCallback(
    (name: string, value: string) => {
      const params = new URLSearchParams(searchParams)
      params.set(name, value)

      return params.toString()
    },
    [searchParams]
  )
  const handleEdit = () => {
    router.push(pathname + "?" + createQueryString("step", "billing-address"), {
      scroll: false,
    })
  }

  const handleToggleSameAsBilling = async () => {
    const next = !sameAsBilling
    setSameAsBilling(next)
    if (!next) {
      // Unchecked: allow editing billing address
      handleEdit()
      return
    }
    // Checked: copy shipping to billing and skip step
    if (cart?.shipping_address) {
      const { id, ...billing_address } = cart.shipping_address
      await updateCart({ billing_address })
      router.push(pathname + "?step=delivery", { scroll: false })
    }
  }

  // Auto-apply same-as-shipping when landing on billing step and no billing set
  // This skips the step by default, but users can come back and uncheck to edit.
  
  useEffect(() => {
    const shouldAutoApply =
      isOpen &&
      sameAsBilling &&
      !!cart?.shipping_address?.address_1 &&
      !compareAddresses(cart.shipping_address!, cart.billing_address || ({} as any))

    if (shouldAutoApply) {
      const apply = async () => {
        const { id, ...billing_address } = cart!.shipping_address!
        await updateCart({ billing_address })
        router.push(pathname + "?step=delivery", { scroll: false })
      }
      apply()
    }
  }, [isOpen, sameAsBilling, cart?.shipping_address, cart?.billing_address, pathname, router])

  const handleSubmit = async (formData: FormData) => {
    await setBillingAddress(formData).catch((e) => {
      setError(e.message)
      return
    })

    router.push(pathname + "?step=delivery", { scroll: false })
  }

  return (
    <Container>
      <div className="flex flex-col gap-y-2">
        <div className="flex small:flex-row flex-col small:items-center justify-between w-full">
          <div className="flex gap-x-2 items-center">
            <Heading
              level="h2"
              className={clx(
                "flex flex-row text-xl gap-x-2 items-center font-medium",
                {
                  "opacity-50 pointer-events-none select-none":
                    !isOpen && !cart?.billing_address?.address_1,
                }
              )}
            >
              Számlázási cím
            </Heading>
            {!isOpen && cart?.billing_address?.address_1 && (
              <CheckCircleSolid className="text-green-600" />
            )}
          </div>
          <div className="flex items-center gap-4">
            {!isOpen && cart?.billing_address?.address_1 && (
              <Text>
                <button
                  onClick={handleEdit}
                  className="text-ui-fg-interactive hover:text-ui-fg-interactive-hover"
                  data-testid="edit-billing-address-button"
                >
                  Szerkesztés
                </button>
              </Text>
            )}
            {cart?.shipping_address?.address_1 && (
              <CheckboxWithLabel
                disabled={cartApprovalStatus === ApprovalStatusType.PENDING}
                label="Számlázási cím megegyezik a szállítási címmel"
                name="same_as_billing"
                checked={sameAsBilling}
                onChange={handleToggleSameAsBilling}
                data-testid="billing-address-checkbox"
              />
            )}
          </div>
        </div>
        {!isOpen && cart?.billing_address?.address_1 && <Divider />}
        {isOpen ? (
          <div>
            <Divider />
            <form action={handleSubmit}>
              <div className="py-2">
                <BillingAddressForm cart={cart} />
              </div>
              <div className="flex flex-col gap-y-2 items-end">
                <SubmitButton
                  className="mt-6"
                  data-testid="submit-address-button"
                >
                  Next step
                </SubmitButton>
                <ErrorMessage
                  error={error}
                  data-testid="address-error-message"
                />
              </div>
            </form>
          </div>
        ) : (
          cart &&
          cart.shipping_address?.address_1 &&
          cart.billing_address?.first_name && (
            <div className="text-small-regular">
              <div className="flex items-start gap-x-8">
                <div className="flex" data-testid="billing-address-summary">
                  <Text className="txt-medium text-ui-fg-subtle">
                    {cart.billing_address.first_name}{" "}
                    {cart.billing_address.last_name},{" "}
                    {cart.billing_address.address_1},{" "}
                    {cart.billing_address.postal_code},{" "}
                    {cart.billing_address.city},{" "}
                    {cart.billing_address.country_code?.toUpperCase()}
                  </Text>
                </div>
              </div>
            </div>
          )
        )}
      </div>
    </Container>
  )
}

export default BillingAddress
