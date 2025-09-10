import AddressSelect from "@/modules/checkout/components/address-select"
import CountrySelect from "@/modules/checkout/components/country-select"
import Input from "@/modules/common/components/input"
import { B2BCart, B2BCustomer } from "@/types"
import { HttpTypes } from "@medusajs/types"
import { Container } from "@medusajs/ui"
import { mapKeys } from "lodash"
import React, { useEffect, useMemo, useState } from "react"

const ShippingAddressForm = ({
  customer,
  cart,
}: {
  customer: B2BCustomer | null
  cart: B2BCart | null
}) => {
  const [formData, setFormData] = useState<Record<string, any>>({
    "shipping_address.first_name": "",
    "shipping_address.last_name": "",
    "shipping_address.address_1": "",
    "shipping_address.company": cart?.company?.name || "",
    "shipping_address.postal_code": "",
    "shipping_address.city": "",
    "shipping_address.country_code": "",
    "shipping_address.province": "",
    "shipping_address.phone": "",
    email: "",
  })

  const countriesInRegion = useMemo(
    () => cart?.region?.countries?.map((c) => c.iso_2),
    [cart?.region]
  )

  // check if customer has saved addresses that are in the current region
  const addressesInRegion = useMemo(
    () =>
      customer?.addresses.filter(
        (a) => a.country_code && countriesInRegion?.includes(a.country_code)
      ),
    [customer?.addresses, countriesInRegion]
  )

  const setFormAddress = (
    address?: HttpTypes.StoreCartAddress,
    email?: string
  ) => {
    address &&
      setFormData((prevState: Record<string, any>) => ({
        ...prevState,
        "shipping_address.first_name": address?.first_name?.toString() || "",
        "shipping_address.last_name": address?.last_name?.toString() || "",
        "shipping_address.address_1": address?.address_1?.toString() || "",
        "shipping_address.company": address?.company?.toString() || "",
        "shipping_address.postal_code": address?.postal_code?.toString() || "",
        "shipping_address.city": address?.city?.toString() || "",
        "shipping_address.country_code":
          address?.country_code?.toString() || "",
        "shipping_address.province": address?.province?.toString() || "",
        "shipping_address.phone": address?.phone?.toString() || "",
      }))

    email &&
      setFormData((prevState: Record<string, any>) => ({
        ...prevState,
        email: email.toString() || "",
      }))
  }

  useEffect(() => {
    if (cart && cart.shipping_address) {
      setFormAddress(cart?.shipping_address)
    }
  }, [cart])

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLInputElement | HTMLSelectElement
    >
  ) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    })
  }

  return (
    <>
      {customer && (addressesInRegion?.length || 0) > 0 && (
        <Container className="mb-6 flex flex-col gap-y-4 p-5">
          <p className="text-small-regular">
            {`Szia ${customer.first_name}! Szeretnéd valamelyik elmentett címedet használni?`}
          </p>
          <AddressSelect
            addresses={customer.addresses}
            addressInput={
              mapKeys(formData, (_, key) =>
                key.replace("shipping_address.", "")
              ) as HttpTypes.StoreCartAddress
            }
            onSelect={setFormAddress}
          />
        </Container>
      )}
      {/* Simplified, clean card without heavy shadows */}
      <div className="rounded-xl bg-white border border-neutral-200 p-4 grid grid-cols-2 gap-4">
        <Input
          label="Keresztnév"
          name="shipping_address.first_name"
          autoComplete="given-name"
          value={formData["shipping_address.first_name"]}
          onChange={handleChange}
          required
          className="h-12 text-base px-5 pt-3.5 pb-3"
          data-testid="shipping-first-name-input"
        />
        <Input
          label="Vezetéknév"
          name="shipping_address.last_name"
          autoComplete="family-name"
          value={formData["shipping_address.last_name"]}
          onChange={handleChange}
          required
          className="h-12 text-base px-5 pt-3.5 pb-3"
          data-testid="shipping-last-name-input"
        />
        <Input
          label="Telefonszám"
          name="shipping_address.phone"
          type="tel"
          autoComplete="tel"
          value={formData["shipping_address.phone"]}
          onChange={handleChange}
          required
          className="h-12 text-base px-5 pt-3.5 pb-3"
          data-testid="shipping-phone-input"
        />
        <Input
          label="Cég neve"
          name="shipping_address.company"
          value={formData["shipping_address.company"]}
          onChange={handleChange}
          autoComplete="organization"
          data-testid="shipping-company-input"
          colSpan={2}
          className="h-12 text-base px-5 pt-3.5 pb-3"
        />
        <Input
          label="Cím"
          name="shipping_address.address_1"
          autoComplete="address-line1"
          value={formData["shipping_address.address_1"]}
          onChange={handleChange}
          required
          data-testid="shipping-address-input"
          colSpan={2}
          className="h-12 text-base px-5 pt-3.5 pb-3"
        />
        <Input
          label="Irányítószám"
          name="shipping_address.postal_code"
          autoComplete="postal-code"
          value={formData["shipping_address.postal_code"]}
          onChange={handleChange}
          required
          data-testid="shipping-postal-code-input"
          colSpan={2}
          className="h-12 text-base px-5 pt-3.5 pb-3"
        />
        <div className="grid small:grid-cols-3 grid-cols-2 gap-4 col-span-2">
          <Input
            label="Város"
            name="shipping_address.city"
            autoComplete="address-level2"
            value={formData["shipping_address.city"]}
            onChange={handleChange}
            required
            className="h-12 text-base px-5 pt-3.5 pb-3"
            data-testid="shipping-city-input"
          />
          <Input
            label="Megye"
            name="shipping_address.province"
            autoComplete="address-level1"
            value={formData["shipping_address.province"]}
            onChange={handleChange}
            className="h-12 text-base px-5 pt-3.5 pb-3"
            data-testid="shipping-province-input"
          />
          <CountrySelect
            className="col-span-2 h-12 text-base"
            name="shipping_address.country_code"
            autoComplete="country"
            region={cart?.region}
            value={formData["shipping_address.country_code"]}
            onChange={handleChange}
            required
            data-testid="shipping-country-select"
          />
        </div>
      </div>
    </>
  )
}

export default ShippingAddressForm
