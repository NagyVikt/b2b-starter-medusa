"use client"

import type { ReactNode } from "react"
import Image from "next/image"
import Link from "next/link"
import { Heading } from "@medusajs/ui"
import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import Button from "@/modules/common/components/button"
import {
  ShoppingCart,
  Phone,
  FileText,
  Timer,
  Shield,
  Truck,
  ChevronRight,
  Sparkles,
  Info,
} from "lucide-react"

/* ----------------------------- tiny helper -------------------------------- */
function cn(...classes: (string | false | null | undefined)[]) {
  return classes.filter(Boolean).join(" ")
}

/* ------------------------------- atoms ------------------------------------ */
type MiniStatProps = { icon: ReactNode; title: string; sub: string }

const MiniStat = ({ icon, title, sub }: MiniStatProps) => {
  return (
    <div className="relative overflow-hidden rounded-2xl border border-white/10 bg-white/[0.06] px-4 py-3 transition-colors hover:bg-white/[0.08]">
      <div className="absolute -right-8 -top-8 h-20 w-20 rounded-full bg-[var(--f1)]/[0.10]" />
      <div className="relative flex items-center gap-3">
        <div className="grid h-9 w-9 place-items-center rounded-xl border border-white/10 bg-black/40 text-white/90">
          {icon}
        </div>
        <div className="min-w-0">
          <p className="text-[13px] font-medium leading-5 text-white/90">
            {title}
          </p>
          <p className="truncate text-[11px] leading-4 text-white/60">{sub}</p>
        </div>
      </div>
    </div>
  )
}

const SponsorChip = ({ children }: { children: ReactNode }) => (
  <span className="inline-flex items-center rounded-full border border-white/10 bg-white/[0.06] px-3 py-1 text-xs font-medium tracking-wide text-white/70">
    {children}
  </span>
)

const Hero = () => {
  return (
    <section
      className="relative w-full min-h-[80vh] border-b border-ui-border-base bg-black overflow-hidden"
      style={{
        ["--f1" as any]: "#E10600", // F1 red
        ["--f1-dk" as any]: "#990300", // darker F1 red for gradients
      }}
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

      {/* F1 red diagonal band — sits under content/wheel */}
      <div
        className="pointer-events-none absolute -right-[14%] -top-[26%] h-[170%] w-[54%] -skew-x-6 z-10"
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

      <div className="relative z-20 mx-auto w-full max-w-[120rem] px-6 sm:px-10 lg:px-12 py-14 sm:py-16 lg:py-24">
        <div className="grid items-center gap-10 lg:grid-cols-12">
          {/* LEFT: copy */}
          <div className="relative z-30 lg:col-span-7">
            <div className="relative rounded-3xl border border-white/[0.12] bg-[var(--panel)] p-6 sm:p-8 md:p-10 shadow-[0_8px_40px_rgba(0,0,0,0.35)]">
              {/* Subtle carbon weave */}
              <div
                className="pointer-events-none absolute inset-0 overflow-hidden rounded-[inherit]"
                aria-hidden
              >
                <div
                  className="absolute inset-0 opacity-[0.06]"
                  style={{
                    backgroundImage:
                      "repeating-linear-gradient(45deg, rgba(255,255,255,0.28) 0 1px, rgba(0,0,0,0.35) 1px 2px)," +
                      "repeating-linear-gradient(-45deg, rgba(0,0,0,0.35) 0 1px, rgba(255,255,255,0.28) 1px 2px)",
                    backgroundSize: "10px 10px, 10px 10px",
                  }}
                />
                <div className="absolute -top-1 left-2 h-1.5 w-28 rounded-b-full bg-[var(--f1)] shadow-[0_0_0_1px_rgba(255,255,255,0.06)_inset,0_10px_30px_rgba(225,6,0,0.35)]" />
              </div>

              <p className="text-[11px] sm:text-xs uppercase tracking-[0.24em] text-white/70">
                Kerekek &amp; gumik
              </p>

              <Heading
                id="hero-heading"
                level="h1"
                className={cn(
                  "mt-1 text-5xl sm:text-6xl leading-[1.02] font-semibold text-white"
                )}
              >
                <span className="text-white">Tehergumi</span>
                <span className="italic text-[var(--f1)] drop-shadow-[0_8px_24px_rgba(225,6,0,0.35)]">
                  net.hu
                </span>
              </Heading>

              <p className="mt-4 sm:mt-5 text-base sm:text-lg leading-7 text-white/85">
                HUBTRACK, AEROTYRE, SUPERWAY és GROUNDSPEED teher- és
                buszabroncsok azonnal, raktárról. Gyors kiszolgálás,
                versenyképes árakon.
              </p>

              <div className="mt-5 flex flex-wrap items-center gap-2.5">
                <SponsorChip>HUBTRACK</SponsorChip>
                <SponsorChip>AEROTYRE</SponsorChip>
                <SponsorChip>SUPERWAY</SponsorChip>
                <SponsorChip>GROUNDSPEED</SponsorChip>
              </div>

              {/* CTAs */}
              <div className="mt-7 flex flex-wrap gap-3">
                <LocalizedClientLink href="/store" aria-label="Bolt megnyitása">
                  <Button
                    className={cn(
                      "group relative isolate rounded-full px-5 py-2.5 text-white",
                      "bg-[var(--f1)] shadow-[0_12px_30px_rgba(225,6,0,0.35)] hover:shadow-[0_18px_40px_rgba(225,6,0,0.45)]",
                      "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--f1)] focus-visible:ring-offset-2 focus-visible:ring-offset-black"
                    )}
                  >
                    <span className="absolute inset-0 -z-10 rounded-full bg-[radial-gradient(120%_80%_at_50%_0%,rgba(173, 173, 173, 0.35)_0%,rgba(236, 236, 236, 0)_70%)] opacity-40" />
                    <ShoppingCart className="mr-2 h-4 w-4" />
                    Bolt
                    <ChevronRight className="ml-1.5 h-4 w-4" />
                  </Button>
                </LocalizedClientLink>

                <Link href="/arlista" aria-label="Árlista megtekintése">
                  <Button className="rounded-full px-5 py-2.5 text-white bg-gradient-to-b from-[var(--f1)] to-[var(--f1-dk)] shadow-[0_10px_24px_rgba(225,6,0,0.30)]">
                    <FileText className="mr-2 h-4 w-4" />
                    Árlista megtekintése
                    <Sparkles className="ml-1.5 h-4 w-4 opacity-80" />
                  </Button>
                </Link>

                <Link
                  href="/contact"
                  aria-label="Kapcsolatfelvétel vagy ajánlatkérés"
                >
                  <Button
                    variant="secondary"
                    className="rounded-full px-5 py-2.5 border border-white/20 bg-white/10 text-white"
                  >
                    <Phone className="mr-2 h-4 w-4" />
                    Kapcsolat / Ajánlatot kérek
                  </Button>
                </Link>
              </div>

              {/* Disclaimer */}
              <div className="mt-4 flex items-start gap-2 text-xs text-white/70">
                <Info className="mt-[2px] h-3.5 w-3.5 shrink-0 opacity-80" />
                <span>Az árak nem tartalmazzák az ÁFÁ-t.</span>
              </div>

              {/* Stats */}
              <div className="mt-6 grid grid-cols-1 gap-3 sm:grid-cols-3">
                <MiniStat
                  icon={<Timer className="h-[18px] w-[18px]" />}
                  title="Gyors kiszolgálás"
                  sub="Rendeléstől akár 24 órán belül"
                />
                <MiniStat
                  icon={<Truck className="h-[18px] w-[18px]" />}
                  title="Országos szállítás"
                  sub="Megbízható partnerekkel"
                />
                <MiniStat
                  icon={<Shield className="h-[18px] w-[18px]" />}
                  title="Garancia"
                  sub="Új, bevizsgált abroncsok"
                />
              </div>
            </div>
          </div>

          {/* RIGHT: wheel + static tach ring */}
          <div className="relative hidden lg:block lg:col-span-5 z-30 h-[560px]">
            {/* decorative rings (stay below the wheel) */}
            <div
              className="pointer-events-none absolute inset-0 -top-6 -left-6 -right-6 -bottom-6 z-0"
              aria-hidden
            >
              <div className="absolute left-1/2 top-1/2 h-[640px] w-[640px] -translate-x-1/2 -translate-y-1/2">
                {/* Soft red glow */}
                <div
                  className="absolute inset-0 rounded-full"
                  style={{
                    background:
                      "radial-gradient(circle at center, rgba(225,6,0,0.22) 0%, rgba(225,6,0,0.10) 36%, rgba(0,0,0,0) 62%)",
                  }}
                />
                {/* Static ticks ring */}
                <div className="absolute inset-0 rounded-full border border-white/10 [mask:radial-gradient(circle,transparent_52%,black_56%,transparent_64%)]" />
                <div className="absolute inset-0 rounded-full [background:conic-gradient(from_90deg,rgba(255,255,255,.24)_0deg,transparent_12deg,transparent_24deg,rgba(225,6,0,.55)_24deg,transparent_36deg)] [mask:radial-gradient(circle,transparent_52%,black_56%,transparent_64%)] opacity-80" />
              </div>
            </div>

            {/* soft glow (below the wheel) */}
            <div
              className="absolute -inset-24 rounded-full blur-3xl z-0"
              style={{
                background:
                  "radial-gradient(closest-side, rgba(225,6,0,.35), transparent 65%)",
              }}
              aria-hidden
            />

            {/* WHEEL — visible, on top */}
            <div className="absolute inset-0 z-10">
              <Image
                src="/wheel.png"
                alt="Teherabroncs kerék — termékfotó"
                fill
                sizes="50vw"
                priority={false}
                className="select-none object-contain drop-shadow-[0_28px_56px_rgba(0,0,0,0.45)] origin-center transform-gpu scale-[1.5]"
                draggable={false}
              />
            </div>
          </div>
        </div>
      </div>

      <div className="pointer-events-none absolute bottom-0 left-0 right-0 h-[3px]">
        <div className="absolute inset-0 bg-[var(--f1)]" />
        <div className="absolute inset-0 bg-[linear-gradient(90deg,transparent_0_25%,rgba(255,255,255,0.75)_25%_50%,transparent_50%_75%,rgba(255,255,255,0.75)_75%_100%)] bg-[length:80px_3px] opacity-40" />
      </div>
    </section>
  )
}

export default Hero
