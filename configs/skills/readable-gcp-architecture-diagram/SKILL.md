---
name: Readable GCP architecture diagram
description: >-
  Use when drawing a customer-facing or reviewable Google Cloud architecture
  figure as draw.io + PNG: white-canvas layout, official icons, labeled edges,
  nested network boxes—without the draw-io plugin skill.
---
# Readable GCP architecture diagram

## Goal
Produce a **clear draw.io + PNG** Google Cloud architecture figure that reads left→right (or top→bottom) at a glance: product cards, official icons, labeled relationships, nested network boxes. Prefer **authoring the figure yourself** (layout + export). Do **not** use the Cursor draw-io plugin skill or its playbooks—those layouts often become hard to read.

## When
- User wants a GCP / hybrid (GCP ↔ on-prem) architecture diagram that looks polished and readable.
- Network flows matter (VPC, VPN, peering, spokes, egress paths) and every edge needs a plain-language label.
- Audience is a customer or a review meeting (not a scratch Mermaid).

## Visual recipe (keep this look)
1. **Canvas:** white background; generous margins; avoid cluttered fill colors.
2. **Outer regions:** large titled boxes (e.g. "Google Cloud" with logo; peer site as a matching box on the right). Nested boxes for reserved CIDR → VPC → subnets when showing address hierarchy—prefer containment over arrow-only nesting.
3. **Product cards:** light shadow, white fill; **icon on the left**, short product label on the right.
4. **Flow:** one clear story direction (usually left→right). No dangling cards that look unconnected.
5. **Edges:**
   - Thick solid = primary traffic (incl. IPsec tunnels)
   - Dashed = control / BGP / peering / spokes
   - **Every edge labeled** with what flows (e.g. Direct VPC egress, IPsec tunnel, BGP route exchange)—not just arrows.
6. **Legend** in a corner for solid vs dashed (and any "draft / TBD" marker).
7. **Title** states the story in one line; keep labels short.

## Icons
1. Source assets from [Google Cloud icons](https://cloud.google.com/icons) (download SVG/PNG Google publishes).
2. Embed used icons into the `.drawio` (e.g. data URI) so the file is self-contained; keep copies under a local `media/icons/` if useful.
3. **Icon priority:** prefer the **newest** official asset from cloud.google.com/icons for each product. Fall back to **legacy console icons** only when the current set has no distinct product icon (e.g. Networking products that share one category glyph) and the figure needs products to look different. Do not use one shared category icon for several different products when distinction matters.
   - Example: Cloud Run → current individual; VPC / Cloud VPN / Cloud Router / NCC → legacy; Google Cloud mark → current logo.
4. Do not invent unofficial glyphs.

## Steps
1. Lock **content** with the operator first (what is draft vs fixed, what must not be recommended, audience language).
2. Sketch the **story** (source → path → destination) and the edge label list before drawing.
3. Build `*.drawio` with the visual recipe above; tune spacing so icons and labels do not clip or overlap.
4. Export PNG with a current draw.io desktop/CLI (record version if asked). Spot-check zoomed: icons, labels, legend, nesting.
5. Deliver `.drawio` + `.png` paths. Do not send to external customers unless the user explicitly asks.
6. If a customer-doc style checker exists for this engagement, run it on the markdown + figures and report `== 0 error(s)` before calling the work done—without pasting checker noise into customer-facing drafts.

## Do not
- Hand off to a draw-io plugin skill as the primary layout engine.
- Leave unlabeled arrows or orphan cards.
- Put engagement-specific secrets, real customer-only IPs, or internal file paths into the figure unless the operator approved that audience.
- Stuff the figure with aside notes that raise cognitive load (example-only placeholder names, "no connector" style contrasts, redundant parenthetical renames).

## Output checklist
- [ ] Left→right (or top→bottom) story is obvious
- [ ] Every runtime edge has a label
- [ ] Solid vs dashed matches the legend
- [ ] Icons are from cloud.google.com/icons; newest official asset preferred, legacy only when current set lacks distinct product icons
- [ ] Nested network ranges use containment boxes when showing hierarchy
- [ ] PNG exported and visually QA'd; sources self-contained in `.drawio`
