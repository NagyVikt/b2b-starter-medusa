"use client"

import { usePathname, useRouter } from "next/navigation"
import { useState } from "react"

export default function SearchBar() {
  const router = useRouter()
  const pathname = usePathname()
  const [q, setQ] = useState("")

  const onSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    const cc = pathname?.split("/").filter(Boolean)[0] || "dk"
    const dest = `/${cc}/store?q=${encodeURIComponent(q.trim())}`
    router.push(dest)
  }

  return (
    <form onSubmit={onSubmit} className="relative mr-2 hidden small:inline-flex">
      <input
        type="search"
        name="q"
        value={q}
        onChange={(e) => setQ(e.target.value)}
        placeholder="Termékek keresése"
        className="bg-gray-100 text-zinc-900 px-4 py-2 rounded-full pr-10 shadow-borders-base hidden small:inline-block"
        aria-label="Termékek keresése"
      />
      <button
        type="submit"
        className="absolute right-2 top-1/2 -translate-y-1/2 text-neutral-600 hover:text-neutral-900"
        aria-label="Keresés indítása"
      >
        🔎
      </button>
    </form>
  )
}

