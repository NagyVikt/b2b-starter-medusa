"use client"

import Image from "next/image"
import { usePathname, useRouter } from "next/navigation"
import { useCallback, useEffect, useMemo, useRef, useState } from "react"
import { Search, X } from "lucide-react"
import LocalizedClientLink from "@/modules/common/components/localized-client-link"

type Suggestion = {
  id: string
  title: string
  handle: string
  thumbnail?: string | null
}

export default function SearchBar() {
  const router = useRouter()
  const pathname = usePathname()
  const [q, setQ] = useState("")
  const [open, setOpen] = useState(false)
  const [loading, setLoading] = useState(false)
  const [items, setItems] = useState<Suggestion[]>([])
  const timer = useRef<NodeJS.Timeout | null>(null)
  const boxRef = useRef<HTMLDivElement>(null)

  const cc = useMemo(
    () => pathname?.split("/").filter(Boolean)[0] || "dk",
    [pathname]
  )

  const fetchSuggestions = useCallback(
    async (term: string) => {
      if (!term || term.trim().length < 2) {
        setItems([])
        return
      }
      setLoading(true)
      try {
        const res = await fetch(`/api/suggest?q=${encodeURIComponent(term)}&countryCode=${cc}`)
        const json = await res.json()
        setItems(json.products || [])
      } catch (_) {
        setItems([])
      } finally {
        setLoading(false)
      }
    },
    [cc]
  )

  const onChange = (val: string) => {
    setQ(val)
    if (timer.current) clearTimeout(timer.current)
    timer.current = setTimeout(() => fetchSuggestions(val), 220)
  }

  const onSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    const dest = `/${cc}/store?q=${encodeURIComponent(q.trim())}`
    setOpen(false)
    router.push(dest)
  }

  useEffect(() => {
    const onClickAway = (e: MouseEvent) => {
      if (!boxRef.current) return
      if (!boxRef.current.contains(e.target as Node)) setOpen(false)
    }
    document.addEventListener("mousedown", onClickAway)
    return () => document.removeEventListener("mousedown", onClickAway)
  }, [])

  return (
    <div ref={boxRef} className="relative mr-2 hidden small:inline-flex w-72">
      <form onSubmit={onSubmit} className="relative flex-1">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-neutral-500" />
        <input
          type="search"
          name="q"
          value={q}
          onFocus={() => setOpen(true)}
          onChange={(e) => onChange(e.target.value)}
          placeholder="Termékek keresése"
          className="bg-gray-100 text-zinc-900 pl-9 pr-8 py-2 rounded-full shadow-borders-base w-full outline-none focus:ring-2 focus:ring-neutral-300"
          aria-label="Termékek keresése"
        />
        {q && (
          <button
            type="button"
            onClick={() => {
              setQ("")
              setItems([])
            }}
            className="absolute right-2 top-1/2 -translate-y-1/2 text-neutral-500 hover:text-neutral-800"
            aria-label="Törlés"
          >
            <X className="h-4 w-4" />
          </button>
        )}
      </form>

      {open && (items.length > 0 || loading) && (
        <div className="absolute top-full mt-2 w-[28rem] -left-16 bg-white border border-neutral-200 rounded-xl shadow-lg overflow-hidden z-50">
          <div className="max-h-72 overflow-auto">
            {loading ? (
              <div className="p-3 text-sm text-neutral-500">Keresés…</div>
            ) : (
              items.map((p) => (
                <LocalizedClientLink
                  key={p.id}
                  href={`/products/${p.handle}`}
                  className="flex items-center gap-3 p-3 hover:bg-neutral-50"
                  onClick={() => setOpen(false)}
                >
                  <div className="relative h-10 w-10 rounded-md bg-neutral-100 overflow-hidden flex-shrink-0">
                    {p.thumbnail ? (
                      <Image
                        src={p.thumbnail}
                        alt={p.title}
                        fill
                        sizes="40px"
                        className="object-cover"
                      />)
                    : (
                      <div className="h-full w-full" />
                    )}
                  </div>
                  <div className="text-sm text-neutral-800 line-clamp-2">{p.title}</div>
                </LocalizedClientLink>
              ))
            )}
          </div>
          <div className="border-t border-neutral-200">
            <button
              className="w-full text-left text-sm text-neutral-700 hover:bg-neutral-50 p-3"
              onClick={() => {
                setOpen(false)
                router.push(`/${cc}/store?q=${encodeURIComponent(q.trim())}`)
              }}
            >
              Összes találat megnyitása
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

