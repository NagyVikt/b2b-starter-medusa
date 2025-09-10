"use client"

import { Heading } from "@medusajs/ui"
import Button from "@/modules/common/components/button"
import Image from "next/image"
import Link from "next/link"
import { Phone, FileText } from "lucide-react"

// Static, image-focused hero (no animation) — Hungarian copy
// Assets used (put these in /public):
//  - /hero.png       → warehouse background
//  - /wheel.png      → isolated truck tire PNG

const Hero = () => {
  return (
    <section className="relative w-full min-h-[78vh] border-b border-ui-border-base bg-neutral-900 overflow-hidden">
      {/* Háttérkép */}
      <Image
        src="/hero.png"
        alt="Gumiraktár háttér"
        fill
        priority
        className="object-cover object-center"
      />
      {/* Fekete árnyékos overlay a jobb olvashatóságért (fehér helyett) */}
      <div className="absolute inset-0 bg-gradient-to-b from-black/70 via-black/50 to-black/30" />

      {/* Tartalom */}
      <div className="relative z-10 mx-auto max-w-7xl px-6 sm:px-10 lg:px-12 py-12 sm:py-16 lg:py-20">
        <div className="grid lg:grid-cols-12 gap-10 items-center">
          {/* Bal oldal: szöveg és CTA-k */}
          <div className="lg:col-span-7">
            <div className="backdrop-blur-xl bg-white/70 border border-white/60 shadow-2xl rounded-3xl p-6 sm:p-8 md:p-10">
              <p className="text-xs tracking-widest uppercase text-neutral-700">
                Kerekek & gumik
              </p>

              <Heading
                level="h1"
                className="text-5xl sm:text-6xl leading-[1.05] font-semibold text-ui-fg-base"
              >
                Teherguminet.hu
              </Heading>

              <p className="mt-5 text-lg leading-8 text-ui-fg-subtle">
                HUBTRACK, AEROTYRE, SUPERWAY és GROUNDSPEED teher- és
                buszabroncsok raktárról.
              </p>

              <div className="mt-6 flex flex-wrap gap-3">
                <Link href="/arlista">
                  <Button className="rounded-2xl px-5 py-2.5">
                    <FileText className="mr-2 h-4 w-4" /> Árlista megtekintése
                  </Button>
                </Link>
                <Link href="/contact">
                  <Button
                    variant="secondary"
                    className="rounded-2xl px-5 py-2.5"
                  >
                    <Phone className="mr-2 h-4 w-4" /> Ajánlatot kérek
                  </Button>
                </Link>
              </div>

              <div className="mt-6 text-sm text-neutral-700">
                Az árak nem tartalmazzák az ÁFÁ-t!
              </div>
            </div>
          </div>

          {/* Jobb oldal: statikus termékkép */}
          <div className="hidden lg:block lg:col-span-5">
            {/* Kerék 3×-os méretben, háttér méret változatlan */}
            <div className="relative h-[560px] xl:h-[640px]">
              {/* Fekete glow a kerék mögé */}
              <div className="absolute -inset-20 rounded-full bg-black/35 blur-3xl" aria-hidden />
              <Image
                src="/wheel.png"
                alt="Teherabroncs kerék — termékfotó"
                fill
                className="object-contain drop-shadow-[0_40px_80px_rgba(0,0,0,0.65)] scale-[3]"
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default Hero
