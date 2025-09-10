import NativeSelect, {
  NativeSelectProps,
} from "@/modules/common/components/native-select"
import { HttpTypes } from "@medusajs/types"
import { forwardRef, useImperativeHandle, useMemo, useRef } from "react"

const CountrySelect = forwardRef<
  HTMLSelectElement,
  NativeSelectProps & {
    region?: HttpTypes.StoreRegion
  }
>(({ placeholder = "Ország", region, defaultValue, ...props }, ref) => {
  const innerRef = useRef<HTMLSelectElement>(null)

  useImperativeHandle<HTMLSelectElement | null, HTMLSelectElement | null>(
    ref,
    () => innerRef.current
  )

  const countryOptions = useMemo(() => {
    const allowed = new Set(["hu", "sk"]) // Hungary, Slovakia

    // If region is provided, prefer its labels but filter to allowed list
    if (region) {
      const inRegion = region.countries
        ?.filter((c) => c.iso_2 && allowed.has(c.iso_2.toLowerCase()))
        .map((country) => ({
          value: country.iso_2.toLowerCase(),
          label: country.display_name,
        }))
      if (inRegion && inRegion.length > 0) return inRegion
    }

    // Fallback: hardcode the two options
    return [
      { value: "hu", label: "Hungary" },
      { value: "sk", label: "Slovakia" },
    ]
  }, [region])

  return (
    <NativeSelect
      ref={innerRef}
      placeholder={placeholder}
      defaultValue={defaultValue}
      {...props}
    >
      {countryOptions?.map(({ value, label }, index) => (
        <option key={index} value={value}>
          {label}
        </option>
      ))}
    </NativeSelect>
  )
})

CountrySelect.displayName = "CountrySelect"

export default CountrySelect
