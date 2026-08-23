---
name: eli5
description: Explains a topic to someone who has never heard of it, using large diagrams and as few words as possible. Use when the user asks to explain something simply, for a beginner, or as if they know nothing about it, wants a visual primer on an unfamiliar concept, or wants to work through a subject from several angles to find the gaps in their own understanding.
disable-model-invocation: true
---

# eli5

Explain the topic to someone hearing about it for the first time. The deliverable is a canvas carried by large diagrams and few words, not prose.

## Constraints

Cut words. Keep the running text under 200 words in total (roughly 400 characters in Japanese), and no sentence longer than about 15 words. If a sentence only survives because of a comma, split it in two.

Let the pictures lead, and draw the thing rather than a diagram of the sentence. Labelled rectangles joined by arrows only restate the words. A recognisable subject carries meaning on its own: a laptop with loose sheets scattered inside it, one folder feeding many places at once, a queue that keeps growing. The test is to cover every label in the figure — if the remaining shape still says something, it is a picture; if it goes blank, it was a sentence in a box. A canvas has no network access, so draw with inline SVG and layout rather than loading images.

The word budget covers words only. Nothing limits the pictures, so spend there freely. Every beat gets its own figure, the last one included. When the mechanism applies to many things, draw three of them rather than one plus "and so on" — repetition is what makes "this happens everywhere" visible at a glance. When something changes, put the before and the after side by side with one large arrow between them.

Name things the way the reader already does. Describe what the thing does in plain words, then give it its real name — "it waits a little longer after every failure", then exponential backoff. Never coin a substitute noun for the real term: a word the reader has to decode is a second piece of jargon, and it leaves them unable to look up what they just learned. When the concept already has a familiar everyday equivalent — a shortcut, a folder, the trash — use that word instead of inventing one.

Reach for an analogy only when it survives this test: the reader has physically done or handled the thing you are pointing at. If the analogy itself needs a sentence of explanation, it is not carrying the explanation — drop it and describe the mechanism plainly. Most topics need no analogy at all, and mixing several is worse than using none.

Write in whatever language the user is writing in.

## Structure

Four beats.

1. Why it exists. The problem in one sentence, with a picture of the broken situation.
2. The central picture. The core mechanism as one large diagram. Give it the most space.
3. How it works. Three steps at most, each one line plus a small visual.
4. Where this explanation breaks. One honest limit of the simplification.

Drop a beat rather than pad it. Three strong beats are better than four padded ones.

## Explaining something local

When the topic is the user's own codebase or a tool they have connected, read the real thing first. The simplification has to be true of their system, not of the concept in general.

## Explaining it to yourself

Everything above aims at a reader who is not you. When the user is working through something for their own understanding, one clean explanation is the wrong deliverable: it settles the topic without showing which parts of it they never had.

Build the same subject two or three times over, each through a different lens, as separate canvases in one turn.

- Structure. What holds what, and what everything leans on. This lens earns its place only when drawn from the real thing — a graph invented to look like a graph is the sentence in a box the constraints already reject. Read the code or the document first, then draw the shape it turns out to have: a hub, a cycle, one node that everything touches.
- Sequence. What happens in what order, and what sits waiting while it happens.
- Contrast. The subject beside the nearest thing it gets mistaken for, side by side, with the one difference that matters drawn large.
- Analogy. Held to a lower bar here than above. An analogy that fails is still worth attempting for yourself, because finding that something has no everyday counterpart is a real result. Say where it broke instead of patching it.

Choose the lenses that suit the subject rather than running all four. Two that fit beat four padded out to a set.

The limits set out above are cut to a stranger's patience and do not apply here. You already hold the context, so thinness is the greater risk: a canvas that fits inside two hundred words can hold only what you already suspected, and there is no gap to find in it. Drop the word budget and the ceiling of three steps. Give the subject as many parts as it turns out to have, and keep the awkward cases rather than rounding them off — an exception is usually the place where the understanding is thinnest.

What stands in for the budget is a test applied to every block of text: does it carry something you could not have got from the figure beside it? Prose that narrates its own picture is what to cut. A section with nothing left after that test was already understood and does not need drawing.

The rules about the pictures are unaffected by length and still hold — the labels test, the real names, drawing the thing rather than the sentence. One more joins them here: a figure must not encode an amount its source never gave. A position along a track or the length of a bar makes a quantitative claim silently, so where the source says only that something got faster, the picture has to say only that too.

Then say which lens came out weakest, and why. That is the reason for building several: the one that would not hold marks where the understanding is thin, and a single explanation can never show that.

That verdict is worth something only if each lens was given its own pass over the source. Before calling one weak, go looking for the facts that only it could carry, the ones no other lens would ever surface. A sequence lens holds nothing until you have hunted for what changes with time — an ordering, a lifetime, a thing that is only valid until the next call. A contrast lens holds nothing until you have found what the subject gets mistaken for. Skip that hunt and every lens after the first comes out thin, and the verdict ends up measuring how hard you looked rather than anything about the subject.

Name each file `<yyyy-mm-dd>-<subject>-<lens>.canvas.tsx`. The names are the record. A second pass over the same subject months later lands beside the first, and the difference between them is worth as much as either one alone.

## Building the canvas

Read `~/.cursor/skills-cursor/canvas/SKILL.md` and follow it for file location, imports, and design rules. Two things matter more here than in an ordinary canvas.

- Scale. Headline numbers and diagrams should be readable from across the room. Running text is secondary.
- Whitespace. Few words read as deliberate only when there is enough space around them.

Where a canvas is not available, write the same structure into a single self-contained HTML file.

## Before delivering

- Can someone hearing the term for the first time follow it from start to finish?
- Is every noun in the canvas a word that exists outside it? An invented label is one more thing to learn.
- Is any sentence there only to look thorough?
- Does every beat carry its own figure, the last one included?
- Cover the labels in each figure. Does the shape still say anything, or was it a sentence in a box?
- When several lenses were built, is it said which one came out weakest, and why?
