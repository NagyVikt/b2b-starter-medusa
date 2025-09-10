"use client"

import { currencySymbolMap } from "@/lib/constants"
import { signup } from "@/lib/data/customer"
import { LOGIN_VIEW } from "@/modules/account/templates/login-template"
import ErrorMessage from "@/modules/checkout/components/error-message"
import { SubmitButton } from "@/modules/checkout/components/submit-button"
import Input from "@/modules/common/components/input"
import { HttpTypes } from "@medusajs/types"
import { Checkbox, Label, Select, Text } from "@medusajs/ui"
import { ChangeEvent, useActionState, useEffect, useState } from "react"

type Props = {
  setCurrentView: (view: LOGIN_VIEW) => void
  regions: HttpTypes.StoreRegion[]
}

interface FormData {
  email: string
  first_name: string
  last_name: string
  company_name: string
  password: string
  company_address: string
  company_city: string
  company_state: string
  company_zip: string
  company_country: string
  currency_code: string
}

const initialFormData: FormData = {
  email: "",
  first_name: "",
  last_name: "",
  company_name: "",
  password: "",
  company_address: "",
  company_city: "",
  company_state: "",
  company_zip: "",
  company_country: "",
  currency_code: "",
}

const placeholder = ({
  placeholder,
  required,
}: {
  placeholder: string
  required: boolean
}) => {
  return (
    <span className="text-ui-fg-muted">
      {placeholder}
      {required && <span className="text-ui-fg-error">*</span>}
    </span>
  )
}

const Register = ({ setCurrentView, regions }: Props) => {
  const [message, formAction] = useActionState(signup, null)
  const [termsAccepted, setTermsAccepted] = useState(false)
  const [accountType, setAccountType] = useState<"personal" | "company">(
    "personal"
  )
  const [formData, setFormData] = useState<FormData>(initialFormData)

  const handleChange = (
    e: ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    const { name, value } = e.target
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  const handleSelectChange = (name: keyof FormData) => (value: string) => {
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  // When switching to company account, prefill currency to EUR if empty
  useEffect(() => {
    if (accountType === "company" && !formData.currency_code) {
      setFormData((prev) => ({ ...prev, currency_code: "eur" }))
    }
  }, [accountType])

  const isValid = termsAccepted &&
    !!formData.email &&
    !!formData.first_name &&
    !!formData.last_name &&
    !!formData.password &&
    (accountType === "personal"
      ? true
      : !!formData.company_name &&
        !!formData.company_address &&
        !!formData.company_city &&
        !!formData.company_zip &&
        !!formData.company_country &&
        !!formData.currency_code)

  // Limit selectable countries to HU/SK with flags and Hungarian labels
  const allowedCountries = [
    { value: "Hungary", label: "🇭🇺 Magyarország" },
    { value: "Slovakia", label: "🇸🇰 Szlovákia" },
  ] as const

  // Limit currency to EUR only
  const allowedCurrencies = [{ value: "eur", label: "EUR (€)" }] as const

  return (
    <div
      className="max-w-sm flex flex-col items-start gap-2 my-8"
      data-testid="register-page"
    >
      <Text className="text-4xl text-neutral-950 text-left mb-4">
        {accountType === "company" ? (
          <>Hozz létre céges (viszonteladói) fiókot.</>
        ) : (
          <>Hozz létre személyes fiókot.</>
        )}
      </Text>
      <form className="w-full flex flex-col" action={formAction}>
        <input type="hidden" name="account_type" value={accountType} />
        <div className="flex items-center gap-3 mb-2">
          <button
            type="button"
            onClick={() => setAccountType("personal")}
            className={`px-3 py-1.5 rounded-full border ${
              accountType === "personal"
                ? "bg-neutral-900 text-white border-neutral-900"
                : "bg-white text-neutral-800 border-neutral-300"
            }`}
          >
            Személyes
          </button>
          <button
            type="button"
            onClick={() => setAccountType("company")}
            className={`px-3 py-1.5 rounded-full border ${
              accountType === "company"
                ? "bg-neutral-900 text-white border-neutral-900"
                : "bg-white text-neutral-800 border-neutral-300"
            }`}
          >
            Cég / Viszonteladó
          </button>
        </div>
        <div className="flex flex-col w-full gap-y-4">
          <Input
            label="Email"
            name="email"
            required
            type="email"
            autoComplete="email"
            data-testid="email-input"
            className="bg-white"
            value={formData.email}
            onChange={handleChange}
          />
          <Input
            label="First name"
            name="first_name"
            required
            autoComplete="given-name"
            data-testid="first-name-input"
            className="bg-white"
            value={formData.first_name}
            onChange={handleChange}
          />
          <Input
            label="Last name"
            name="last_name"
            required
            autoComplete="family-name"
            data-testid="last-name-input"
            className="bg-white"
            value={formData.last_name}
            onChange={handleChange}
          />
          {accountType === "company" && (
            <Input
              label="Cégnév"
              name="company_name"
              required
              autoComplete="organization"
              data-testid="company-name-input"
              className="bg-white"
              value={formData.company_name}
              onChange={handleChange}
            />
          )}
          <Input
            label="Password"
            name="password"
            required
            type="password"
            autoComplete="new-password"
            data-testid="password-input"
            className="bg-white"
            value={formData.password}
            onChange={handleChange}
          />
          {accountType === "company" && (
            <>
              <Input
                label="Cég címe"
                name="company_address"
                required
                autoComplete="address"
                data-testid="company-address-input"
                className="bg-white"
                value={formData.company_address}
                onChange={handleChange}
              />
              <Input
                label="Város"
                name="company_city"
                required
                autoComplete="city"
                data-testid="company-city-input"
                className="bg-white"
                value={formData.company_city}
                onChange={handleChange}
              />
              <Input
                label="Megye"
                name="company_state"
                autoComplete="state"
                data-testid="company-state-input"
                className="bg-white"
                value={formData.company_state}
                onChange={handleChange}
              />
              <Input
                label="Irányítószám"
                name="company_zip"
                required
                autoComplete="postal-code"
                data-testid="company-zip-input"
                className="bg-white"
                value={formData.company_zip}
                onChange={handleChange}
              />
              <Select
                name="company_country"
                required
                autoComplete="country"
                data-testid="company-country-input"
                value={formData.company_country}
                onValueChange={handleSelectChange("company_country")}
              >
                <Select.Trigger className="rounded-full h-10 px-4">
                  <Select.Value
                    placeholder={placeholder({
                      placeholder: "Válassz országot",
                      required: true,
                    })}
                  />
                </Select.Trigger>
              <Select.Content>
                {allowedCountries.map((c) => (
                  <Select.Item key={c.value} value={c.value}>
                    {c.label}
                  </Select.Item>
                ))}
              </Select.Content>
              </Select>
              <Select
                name="currency_code"
                required
                autoComplete="currency"
                data-testid="company-currency-input"
                value={formData.currency_code}
                onValueChange={handleSelectChange("currency_code")}
              >
                <Select.Trigger className="rounded-full h-10 px-4">
                  <Select.Value
                    placeholder={placeholder({
                      placeholder: "Válassz pénznemet",
                      required: true,
                    })}
                  />
                </Select.Trigger>
              <Select.Content>
                {allowedCurrencies.map((c) => (
                  <Select.Item key={c.value} value={c.value}>
                    {c.label}
                  </Select.Item>
                ))}
              </Select.Content>
              </Select>
            </>
          )}
        </div>
        <div className="border-b border-neutral-200 my-6" />
        <ErrorMessage error={message} data-testid="register-error" />
        <div className="flex items-center gap-2">
          <Checkbox
            name="terms"
            id="terms-checkbox"
            data-testid="terms-checkbox"
            checked={termsAccepted}
            onCheckedChange={(checked) => setTermsAccepted(!!checked)}
          ></Checkbox>
          <Label
            id="terms-label"
            className="flex items-center text-ui-fg-base !text-xs hover:cursor-pointer !transform-none"
            htmlFor="terms-checkbox"
            data-testid="terms-label"
          >
            I agree to the terms and conditions.
          </Label>
        </div>
        <SubmitButton
          className="w-full mt-6"
          data-testid="register-button"
          disabled={!isValid}
        >
          Regisztráció
        </SubmitButton>
      </form>
      <span className="text-center text-ui-fg-base text-small-regular mt-6">
        Már van fiókod?{" "}
        <button
          onClick={() => setCurrentView(LOGIN_VIEW.LOG_IN)}
          className="underline"
        >
          Bejelentkezés
        </button>
        .
      </span>
    </div>
  )
}

export default Register
