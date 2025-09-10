import { getBaseURL } from "@/lib/util/env"
import { Toaster } from "@medusajs/ui"
import { Analytics } from "@vercel/analytics/next"
import { GeistSans } from "geist/font/sans"
import { Metadata } from "next"
import "@/styles/globals.css"

export const metadata: Metadata = {
  metadataBase: new URL(getBaseURL()),
}

export default function RootLayout(props: { children: React.ReactNode }) {
  const backend = process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL
  let backendOrigin: string | null = null
  try {
    backendOrigin = backend ? new URL(backend).origin : null
  } catch {}
  return (
    <html lang="en" data-mode="light" className={GeistSans.variable}>
      <head>
        {backendOrigin && (
          <>
            <link rel="preconnect" href={backendOrigin} />
            <link rel="dns-prefetch" href={backendOrigin} />
          </>
        )}
      </head>
      <body>
        <main className="relative">{props.children}</main>
        <Toaster className="z-[99999]" position="bottom-left" />
        <Analytics />
      </body>
    </html>
  )
}
