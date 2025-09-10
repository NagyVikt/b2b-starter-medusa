import { Metadata } from "next"

export const metadata: Metadata = {
  title: "Árlista | teherguminet.hu",
  description: "Teherautó és busz gumiabroncsok aktuális nettó árlistája.",
}

type Row = {
  meretLeiras: string
  marka: string
  nettoEur: number
  nettoHuf: number
  mintaTipus: string
}

const rows: Row[] = [
  { meretLeiras: "215/75R17.5-16 135/133J REGIONAL T11", marka: "HUBTRACK", nettoEur: 155, nettoHuf: 61744, mintaTipus: "PÓTKOCSI" },
  { meretLeiras: "315/70R22.5-18 156/150L HIGHWAY D11", marka: "HUBTRACK", nettoEur: 296, nettoHuf: 118272, mintaTipus: "HÚZÓ" },
  { meretLeiras: "315/70R22.5-18 156/150L REGIONAL D11", marka: "HUBTRACK", nettoEur: 307, nettoHuf: 122610, mintaTipus: "HÚZÓ" },
  { meretLeiras: "295/60R22.5-16 150/147L REGIONAL D11", marka: "HUBTRACK", nettoEur: 255, nettoHuf: 101775, mintaTipus: "HÚZÓ" },
  { meretLeiras: "295/80R22.5-16 152/148M REGIONAL D11", marka: "HUBTRACK", nettoEur: 326, nettoHuf: 130399, mintaTipus: "HÚZÓ" },
  { meretLeiras: "435/50R19.5-20 160J HIGHWAY T11", marka: "HUBTRACK", nettoEur: 354, nettoHuf: 141304, mintaTipus: "PÓTKOCSI" },
  { meretLeiras: "445/45R19.5-20 160J HIGHWAY T11", marka: "HUBTRACK", nettoEur: 343, nettoHuf: 136803, mintaTipus: "PÓTKOCSI" },
  { meretLeiras: "235/75R17.5-18 143/141J REGIONAL T11", marka: "HUBTRACK", nettoEur: 176, nettoHuf: 70192, mintaTipus: "PÓTKOCSI" },
  { meretLeiras: "315/70R22.5-18 156/150L REGIONAL S23", marka: "HUBTRACK", nettoEur: 287, nettoHuf: 114751, mintaTipus: "KORMÁNYZOTT" },
  { meretLeiras: "295/60R22.5-16 150/147K REGIONAL D22", marka: "HUBTRACK", nettoEur: 262, nettoHuf: 104786, mintaTipus: "HÚZÓ" },
  { meretLeiras: "315/60R22.5-18 154/150L HIGHWAY S11", marka: "HUBTRACK", nettoEur: 265, nettoHuf: 105644, mintaTipus: "KORMÁNYZOTT" },
  { meretLeiras: "295/60R22.5-16 150/147L HIGHWAY D11", marka: "HUBTRACK", nettoEur: 252, nettoHuf: 100634, mintaTipus: "HÚZÓ" },
  { meretLeiras: "205/65R17.5-16 129/127J REGIONAL T11", marka: "HUBTRACK", nettoEur: 136, nettoHuf: 54117, mintaTipus: "PÓTKOCSI" },
  { meretLeiras: "315/60R22.5-20PR SWS02", marka: "AEROTYRE", nettoEur: 249, nettoHuf: 99228, mintaTipus: "KORMÁNYZOTT" },
  { meretLeiras: "315/60R22.5-20PR SWD03", marka: "SUPERWAY", nettoEur: 263, nettoHuf: 104898, mintaTipus: "HÚZÓ" },
  { meretLeiras: "315/70R22.5-18PR SWS02", marka: "SUPERWAY", nettoEur: 248, nettoHuf: 98820, mintaTipus: "KORMÁNYZOTT" },
  { meretLeiras: "315/70R22.5-18PR SWD03", marka: "SUPERWAY", nettoEur: 267, nettoHuf: 106548, mintaTipus: "HÚZÓ" },
  { meretLeiras: "315/80R22.5-20PR SWS02", marka: "SUPERWAY", nettoEur: 274, nettoHuf: 109449, mintaTipus: "KORMÁNYZOTT" },
  { meretLeiras: "315/80R22.5-20PR SWD03", marka: "SUPERWAY", nettoEur: 297, nettoHuf: 118725, mintaTipus: "HÚZÓ" },
  { meretLeiras: "385/55R22.5-20PR SWS02", marka: "SUPERWAY", nettoEur: 276, nettoHuf: 110079, mintaTipus: "KORMÁNYZOTT/PÓTKOCSI" },
  { meretLeiras: "385/55R22.5-20PR SWS04", marka: "SUPERWAY", nettoEur: 276, nettoHuf: 110079, mintaTipus: "KORMÁNYZOTT/PÓTKOCSI" },
  { meretLeiras: "385/65R22.5-20PR SWS04", marka: "SUPERWAY", nettoEur: 300, nettoHuf: 119718, mintaTipus: "KORMÁNYZOTT/PÓTKOCSI" },
  { meretLeiras: "295/80R22.5-18PR SWS02", marka: "SUPERWAY", nettoEur: 253, nettoHuf: 101100, mintaTipus: "KORMÁNYZOTT" },
  { meretLeiras: "295/80R22.5-18PR GSVS02", marka: "GROUNDSPEED", nettoEur: 273, nettoHuf: 108828, mintaTipus: "HÚZÓ" },
]

function fmtEUR(v: number) {
  return v.toLocaleString("hu-HU", {
    style: "currency",
    currency: "EUR",
    maximumFractionDigits: 0,
  })
}

function fmtHUF(v: number) {
  return v.toLocaleString("hu-HU", {
    style: "currency",
    currency: "HUF",
    maximumFractionDigits: 0,
  })
}

export default async function ArlistaPage() {
  return (
    <div className="bg-neutral-100">
      <div className="content-container py-10">
        <h1 className="text-3xl font-semibold text-neutral-900 mb-2">Árlista</h1>
        <p className="text-neutral-600 mb-6">
          Teherautó és busz gumiabroncsok aktuális nettó árai. Az árak nem
          tartalmazzák az ÁFÁ-t.
        </p>

        <div className="overflow-x-auto rounded-2xl bg-white shadow-borders-base">
          <table className="min-w-full text-sm">
            <thead className="bg-neutral-50 text-neutral-700">
              <tr>
                <th className="text-left p-3">MÉRET LEÍRÁS</th>
                <th className="text-left p-3">MÁRKA</th>
                <th className="text-right p-3">NETTÓ ÁR (EUR)</th>
                <th className="text-right p-3">NETTÓ ÁR (FT)</th>
                <th className="text-left p-3">MINTA TÍPUS</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r, i) => (
                <tr key={`${r.meretLeiras}-${i}`} className={i % 2 ? "bg-white" : "bg-neutral-50/40"}>
                  <td className="p-3 whitespace-pre-wrap">{r.meretLeiras}</td>
                  <td className="p-3">{r.marka}</td>
                  <td className="p-3 text-right">{fmtEUR(r.nettoEur)}</td>
                  <td className="p-3 text-right">{fmtHUF(r.nettoHuf)}</td>
                  <td className="p-3">{r.mintaTipus}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <p className="text-neutral-600 mt-4">Az árak nem tartalmazzák az ÁFÁ-t!</p>
      </div>
    </div>
  )
}

