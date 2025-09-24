import { listCollections } from "@/lib/data/collections"
import { getRegion } from "@/lib/data/regions"
import ProductRail from "@/modules/home/components/featured-products/product-rail"

export default async function FeaturedProducts({
  countryCode,
}: {
  countryCode: string
}) {
  const [{ collections }, region] = await Promise.all([
    listCollections({
      limit: "3",
      fields: "*products",
    }),
    getRegion(countryCode),
  ])

  if (!collections || !region) {
    return null
  }

  return (
    <ul className="flex flex-col gap-x-6 bg-neutral-100">
      {collections.map((collection) => (
        <li key={collection.id}>
          <ProductRail collection={collection} region={region} />
        </li>
      ))}
    </ul>
  )
}
