"use client"

import { motion } from "framer-motion"
import { Heading } from "@medusajs/ui"
import Button from "@/modules/common/components/button"
import Image from "next/image"
import Link from "next/link"
import { Phone, Search, Truck, Car } from "lucide-react"

// Minimal, wheel-focused hero for a tire/wheel dealership
// - Clean iOS-style glass card
// - Simple two CTAs
// - Lightweight size search (kept because you liked it)
// - Subtle rotating wheel illustration (no extra assets required)

const WheelGraphic = () => {
  return (
    <motion.svg
      viewBox="0 0 200 200"
      xmlns="http://www.w3.org/2000/svg"
      className="h-64 w-64 drop-shadow-2xl"
      aria-hidden
      animate={{ rotate: 360 }}
      transition={{ repeat: Infinity, duration: 18, ease: "linear" }}
    >
      {/* Tire */}
      <circle cx="100" cy="100" r="95" fill="rgba(0,0,0,0.85)" />
      <circle cx="100" cy="100" r="82" fill="#111" />
      {/* Sidewall highlights */}
      <circle
        cx="100"
        cy="100"
        r="90"
        fill="none"
        stroke="white"
        strokeOpacity="0.08"
        strokeWidth="6"
      />
      {/* Rim */}
      <circle cx="100" cy="100" r="58" fill="#d4d4d4" />
      <circle cx="100" cy="100" r="52" fill="#e5e5e5" />
      {/* Spokes */}
      {Array.from({ length: 6 }).map((_, i) => {
        const angle = (i * Math.PI) / 3
        const x1 = 100 + Math.cos(angle) * 10
        const y1 = 100 + Math.sin(angle) * 10
        const x2 = 100 + Math.cos(angle) * 52
        const y2 = 100 + Math.sin(angle) * 52
        return (
          <line
            key={i}
            x1={x1}
            y1={y1}
            x2={x2}
            y2={y2}
            stroke="#a3a3a3"
            strokeWidth="8"
            strokeLinecap="round"
          />
        )
      })}
      <circle cx="100" cy="100" r="14" fill="#9ca3af" />
      <circle cx="100" cy="100" r="6" fill="#6b7280" />
    </motion.svg>
  )
}

const Hero = () => {
  return (
    <div className="relative w-full min-h-[78vh] border-b border-ui-border-base bg-neutral-100 overflow-hidden">
      {/* Background */}
      <Image
        src="/hero-image.jpg"
        alt="Tire & wheel background"
        fill
        priority
        className="object-cover object-center opacity-95"
      />
      <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-black/20 to-white/70" />

      {/* Foreground */}
      <div className="relative z-10 mx-auto max-w-7xl px-6 sm:px-10 lg:px-12 py-12 sm:py-16 lg:py-20">
        <div className="grid lg:grid-cols-12 gap-10 items-center">
          {/* Copy + actions */}
          <motion.div
            initial={{ y: 24, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ duration: 0.55, ease: "easeOut" }}
            className="lg:col-span-7"
          >
            <div className="backdrop-blur-xl bg-white/60 border border-white/60 shadow-2xl rounded-3xl p-6 sm:p-8 md:p-10">
              <p className="text-xs tracking-widest uppercase text-neutral-700">
                Wheels & tires
              </p>

              <Heading
                level="h1"
                className="text-5xl sm:text-6xl leading-[1.05] font-semibold text-ui-fg-base"
              >
                Built for grip. Designed to roll.
              </Heading>

              <p className="mt-5 text-lg leading-8 text-ui-fg-subtle">
                Premium car, truck & bus wheels and tires — curated for safety,
                longevity, and style.
              </p>

              {/* CTAs */}
              <div className="mt-6 flex flex-wrap gap-3">
                <Link href="/store?category=tires">
                  <Button className="rounded-2xl px-5 py-2.5">
                    <Truck className="mr-2 h-4 w-4" /> Shop tires
                  </Button>
                </Link>
                <Link href="/store?category=wheels">
                  <Button
                    variant="secondary"
                    className="rounded-2xl px-5 py-2.5"
                  >
                    <Car className="mr-2 h-4 w-4" /> Shop wheels
                  </Button>
                </Link>
                <Link href="/contact">
                  <Button
                    variant="secondary"
                    className="rounded-2xl px-5 py-2.5"
                  >
                    <Phone className="mr-2 h-4 w-4" /> Call an expert
                  </Button>
                </Link>
              </div>

              {/* Simple size search */}
              <motion.div
                initial={{ opacity: 0, y: 8 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.1, duration: 0.45 }}
                className="mt-7"
              >
                <div className="rounded-2xl bg-white/70 backdrop-blur-xl border border-white/60 shadow-xl p-3">
                  <div className="grid grid-cols-3 gap-3">
                    {[
                      { label: "Width", placeholder: "205" },
                      { label: "Aspect", placeholder: "55" },
                      { label: "Rim", placeholder: "R16" },
                    ].map((f) => (
                      <div key={f.label}>
                        <label className="block text-[10px] uppercase tracking-wide text-neutral-500 mb-1">
                          {f.label}
                        </label>
                        <input
                          className="w-full h-11 rounded-xl border border-neutral-200 bg-white px-3 text-sm focus:outline-none focus:ring-2 focus:ring-black/10"
                          placeholder={f.placeholder}
                          defaultValue={f.placeholder}
                        />
                      </div>
                    ))}
                  </div>
                  <div className="mt-3 flex justify-end">
                    <Link href="/store">
                      <Button className="rounded-2xl h-11 px-5">
                        <Search className="h-4 w-4 mr-2" /> Find tires
                      </Button>
                    </Link>
                  </div>
                </div>
              </motion.div>
            </div>
          </motion.div>

          {/* Right: rotating wheel graphic */}
          <motion.div
            initial={{ opacity: 0, x: 24 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6, ease: "easeOut" }}
            className="hidden lg:flex lg:col-span-5 items-center justify-center"
          >
            <div className="relative">
              <div className="absolute -inset-6 rounded-full bg-white/20 blur-2xl" />
              <div className="relative rounded-full bg-white/70 backdrop-blur-2xl border border-white/60 p-8 shadow-2xl">
                <WheelGraphic />
              </div>
            </div>
          </motion.div>
        </div>
      </div>
    </div>
  )
}

export default Hero
