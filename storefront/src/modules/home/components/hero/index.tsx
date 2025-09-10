"use client"

import { Heading } from "@medusajs/ui"
import Button from "@/modules/common/components/button"
import Image from "next/image"
import Link from "next/link"
import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import { ShoppingCart, Phone, FileText } from "lucide-react"

const Hero = () => {
  return (
    <section
      className="relative w-full min-h-[80vh] border-b border-ui-border-base bg-black overflow-hidden"
      style={{ ["--f1" as any]: "#E10600" }} // F1 red
    >
      {/* Background warehouse */}
      <Image
        src="/hero.png"
        alt="Gumiraktár háttér"
        fill
        priority
        sizes="100vw"
        className="object-cover object-center opacity-90"
      />

      {/* Dark-to-transparent overlay for contrast */}
      <div className="absolute inset-0 bg-gradient-to-b from-black/80 via-black/60 to-black/40" />

      {/* F1 red diagonal band */}
      <div
        className="pointer-events-none absolute -right-[14%] -top-[26%] h-[170%] w-[54%] -skew-x-6"
        aria-hidden
      >
        <div className="h-full w-full bg-[var(--f1)]/95 shadow-[0_0_120px_20px_rgba(225,6,0,0.35)]" />
        <div
          className="absolute inset-0 mix-blend-overlay opacity-25"
          style={{
            backgroundImage:
              "linear-gradient(45deg, rgba(255,255,255,.9) 25%, transparent 25%), linear-gradient(-45deg, rgba(255,255,255,.9) 25%, transparent 25%), linear-gradient(45deg, transparent 75%, rgba(255,255,255,.9) 75%), linear-gradient(-45deg, transparent 75%, rgba(255,255,255,.9) 75%)",
            backgroundSize: "22px 22px",
            backgroundPosition: "0 0, 0 11px, 11px -11px, -11px 0",
          }}
        />
      </div>

      {/* Content */}
      <div className="relative z-20 w-full px-6 sm:px-10 lg:px-12 py-14 sm:py-16 lg:py-20">
        <div className="grid lg:grid-cols-12 gap-10 items-center">
          {/* Left: copy + CTAs */}
          <div className="lg:col-span-7 relative z-30">
            {" "}
            {/* ensure above wheel */}
            <div
              className="relative backdrop-blur-xl rounded-3xl p-6 sm:p-8 md:p-10 shadow-2xl
                            bg-gradient-to-br from-white/90 to-white/70 border border-white/70"
            >
              {/* subtle red accent line */}
              <div className="absolute -top-1 left-0 h-1.5 w-28 bg-[var(--f1)] rounded-r-full" />

              <p className="text-[11px] sm:text-xs tracking-[0.22em] uppercase text-neutral-700">
                Kerekek & gumik
              </p>

              <Heading
                level="h1"
                className="text-5xl sm:text-6xl leading-[1.02] font-semibold"
              >
                <span className="text-neutral-900">Tehergumi</span>
                <span className="text-[var(--f1)]">net.hu</span>
              </Heading>

              <p className="mt-4 sm:mt-5 text-base sm:text-lg leading-7 text-neutral-800">
                HUBTRACK, AEROTYRE, SUPERWAY és GROUNDSPEED teher- és
                buszabroncsok raktárról.
              </p>

              {/* CTAs */}
              <div className="mt-6 flex flex-wrap gap-3">
                <LocalizedClientLink href="/store" aria-label="Bolt megnyitása">
                  <Button
                    className="rounded-full px-5 py-2.5 bg-[var(--f1)] text-white shadow-md
                               transition-all duration-200 hover:-translate-y-0.5 hover:shadow-[0_10px_26px_rgba(225,6,0,.35)]
                               focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--f1)] focus-visible:ring-offset-2 focus-visible:ring-offset-white"
                  >
                    <ShoppingCart className="mr-2 h-4 w-4" />
                    Bolt
                  </Button>
                </LocalizedClientLink>

                <Link href="/arlista" aria-label="Árlista megtekintése">
                  <Button className="rounded-full px-5 py-2.5 bg-[var(--f1)] text-white shadow-md transition-all duration-200 hover:-translate-y-0.5 hover:shadow-[0_10px_26px_rgba(225,6,0,.35)] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--f1)] focus-visible:ring-offset-2 focus-visible:ring-offset-white">
                    <FileText className="mr-2 h-4 w-4" />
                    Árlista megtekintése
                  </Button>
                </Link>

                <Link
                  href="/contact"
                  aria-label="Kapcsolatfelvétel vagy ajánlatkérés"
                >
                  <Button
                    variant="secondary"
                    className="rounded-full px-5 py-2.5 border border-neutral-300 bg-white/85 text-neutral-900
                               transition-all duration-150 hover:bg-white hover:-translate-y-0.5 hover:shadow-md
                               focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black/30 focus-visible:ring-offset-2 focus-visible:ring-offset-white"
                  >
                    <Phone className="mr-2 h-4 w-4" />
                    Kapcsolat / Ajánlatot kérek
                  </Button>
                </Link>
              </div>

              <div className="mt-4 text-xs sm:text-sm text-neutral-700">
                Az árak nem tartalmazzák az ÁFÁ-t.
              </div>
            </div>
          </div>

          {/* Right: wheel image */}
          <div className="hidden lg:block lg:col-span-5">
            <div className="relative h-[560px] xl:h-[640px] pointer-events-none">
              {" "}
              {/* let clicks pass through */}
              {/* red glow */}
              <div
                className="absolute -inset-24 rounded-full blur-3xl"
                style={{
                  background:
                    "radial-gradient(closest-side, rgba(225,6,0,.35), transparent 65%)",
                }}
                aria-hidden
              />
              <Image
                src="/wheel.png"
                alt="Teherabroncs kerék — termékfotó"
                fill
                sizes="50vw"
                className="object-contain drop-shadow-[0_40px_80px_rgba(0,0,0,0.65)] scale-[2] select-none"
                draggable={false}
                priority
              />
            </div>
          </div>
        </div>
      </div>

      {/* slim racing line at the bottom */}
      <div className="absolute bottom-0 left-0 right-0 h-1 bg-[var(--f1)]" />
    </section>
  )
}

export default Hero
