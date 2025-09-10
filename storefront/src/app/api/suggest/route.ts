import { NextResponse } from "next/server"
import { sdk } from "@/lib/config"
import { getRegion } from "@/lib/data/regions"
import { getAuthHeaders } from "@/lib/data/cookies"

export async function GET(req: Request) {
  try {
    const { searchParams } = new URL(req.url)
    const q = (searchParams.get("q") || "").trim()
    const countryCode = (searchParams.get("countryCode") || "").toLowerCase()

    if (!q || q.length < 2 || !countryCode) {
      return NextResponse.json({ products: [] })
    }

    const region = await getRegion(countryCode)
    const headers = {
      ...(await getAuthHeaders()),
    }

    const { products } = await sdk.client.fetch<{ products: any[] }>(
      "/store/products",
      {
        method: "GET",
        credentials: "include",
        query: {
          q,
          limit: 6,
          region_id: region?.id,
          fields: "+thumbnail,handle,title",
        },
        headers,
        cache: "no-store",
      }
    )

    return NextResponse.json({
      products: (products || []).map((p) => ({
        id: p.id,
        title: p.title,
        handle: p.handle,
        thumbnail: p.thumbnail,
      })),
    })
  } catch (e: any) {
    return NextResponse.json({ products: [], error: e?.message }, { status: 200 })
  }
}

