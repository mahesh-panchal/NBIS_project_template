# Writing style

Applies to code comments, `docs/advice/*.md`, the closing report
(`docs/closing_report/closing_report.qmd`), `docs/decisions/*.md`, commit
messages, and PR/review comments. Does not apply to conversational
replies to the user in the current session — those follow the harness's
own tone conventions. Grounded in cognitive-load and technical-writing
research, not house style — see [References](#references).

## Standing rules

1. **Terse prose.** Short declarative sentences, active voice, no hedges
   or meta-commentary ("it's worth noting," "note that," "worth
   mentioning"). State the fact or rule directly instead of narrating
   that you're about to explain it.
2. **Never "correct" established terminology.** A tool's actual name, a
   CLI flag, a package name, or a field's standard term is not a prose
   style choice — leave it exactly as the ecosystem spells it, even
   inside otherwise-edited prose.
3. **No forward references.** Don't write "as shown below" or "we'll
   cover this later" — state the fact where it's needed, or reorder so
   the explanation comes first. A comment or doc section should make
   sense read in isolation.
4. **Scope to the immediate task, not the whole topic.** A code comment
   supports the one line/block it sits above; an advice-doc section
   supports the reader doing the thing that section is under.
   Exhaustively documenting every option, edge case, or internal
   mechanism belongs in a reference doc (if one exists) or in the code
   itself, not narrated in prose nearby.

## The review checklist

Run structural checks before line-editing — they catch whole-section
problems sentence-level fixes can't reach. Most apply to both comments
and longer documentation; a few (marked) matter mainly for longer docs.

1. **Mode check** *(docs, not comments)*. Per the
   [Diátaxis framework](https://diataxis.fr/), documentation has four
   distinct modes: tutorial, how-to, reference, explanation. Know which
   one a given doc is. A paragraph that reads as "here's the complete set
   of X" inside a how-to has drifted into reference mode — rewrite as one
   representative example plus a pointer, don't just shorten the
   enumeration in place.
2. **Task check.** Per Carroll's minimalism, does this sentence/paragraph
   support something the reader is about to do or understand right now?
   A true, accurate fact that supports no immediate step is still a cut.
   Prefer noting how to recognise and recover from a problem over
   exhaustively enumerating every way it could occur in advance.
3. **Narrative-arc check** *(docs, not comments)*. Does a doc's section
   order read as a line — tension then resolution, concept then
   consequence — rather than a flat topic list? Practitioner-level
   guidance (Atkinson); use as a tiebreaker, not a hard rule.
4. **Artifact-vs-narration check.** Keep the one canonical working
   artifact written out in full (the exact command, the complete config,
   the actual code) — that's what a reader can copy or diff against
   later. Cut narration of internal branches, alternate paths, or edge
   cases that the artifact itself doesn't need explained; let the code
   speak for the mechanism.
5. **Coherence check.** The largest-effect-size finding in Mayer's
   multimedia learning principles: if deleting a sentence doesn't weaken
   the point it sits in, delete it — regardless of whether it's true or
   interesting.
6. **Justification-clause check.** A specific, common case of #2/#5:
   watch for "X, because Y" or "this matters because Y" where Y is a fact
   not otherwise needed near this sentence. Cut Y, or move it to where
   it's actually needed.
7. **Signaling check.** A list mixing universal concepts and
   product-specific names needs one sentence up front saying which is
   which.
8. **Split-attention check.** A comment's explanation must sit adjacent
   to the code it explains; a doc's explanation must sit adjacent to the
   command/config block it explains. Flag anything requiring the reader
   to re-hold an earlier block in memory ("as configured above").
9. **Redundancy check.** Where the code or an example already shows
   something verbatim, prose shouldn't re-derive or re-explain it
   field-by-field — name only what matters, or why.
10. **Curse-of-knowledge check.** Fluency with a topic hides the gaps in
    your own explanation of it — for anything non-trivial, an
    independent no-context read catches more than a self-re-read.
11. **Expertise-reversal check.** Heavy scaffolding that helps a novice
    can actively cost an expert reading the same sentence. For
    mixed-audience material (this template's users range from first-time
    NBIS support staff to experienced developers), keep beginner aids
    skippable in under a second — a short parenthetical an expert's eye
    slides past — rather than a separate explanatory sentence.
12. **Density re-check after any accuracy fix.** Correcting a factual
    error tends to add supporting detail, not remove it. Immediately
    after fixing a wrong claim, re-scan that specific spot against checks
    1/2/5/9 — don't assume correctness was the only thing that changed.
13. **Accuracy pass.** Verify commands, config, flag names, and behavior
    against current reality (the actual code, current official docs) —
    don't rely on training-data recall for anything version- or
    date-sensitive.
14. **Style pass.** Apply the standing rules above. Run this last — it's
    the cheapest to fix and shouldn't gate the structural checks before
    it.

## Length calibration by artifact type

- **Inline code comment** (`code/modules/*.nf`, `code/bin/*`): 1-3 lines.
  State the exit condition/behavior/non-obvious *why*; if it needs more
  than that, the full rationale belongs in a linked decision record, not
  the comment.
- **Commit message / PR description:** state the change and, if
  non-obvious, the reason — not a chronological narration of how you got
  there.
- **Review or PR comment:** state the finding or recommendation directly.
  Don't narrate your own reasoning process or explain why you're
  mentioning something.
- **`docs/advice/*.md`:** apply the full checklist; task check and mode
  check matter most, since these are read while trying to do something
  in the repo.
- **`docs/decisions/*.md`:** the one place the *full* rationale belongs.
  Still terse sentence-by-sentence, but comprehensive is correct here,
  not a defect — this is where a comment's "why" should point to.

## References

1. Cognitive load theory (Sweller) — working memory capacity is limited,
   and load splits into intrinsic, extraneous, and germane categories.
   <https://en.wikipedia.org/wiki/Cognitive_load>
2. Split-attention effect (Chandler & Sweller, 1992) — separating a
   diagram or code block from the text explaining it forces the reader
   to hold one in memory while processing the other, at a measurable
   cost to learning.
   <https://en.wikipedia.org/wiki/Split-attention_effect>
3. Multimedia learning principles (Mayer) — coherence, signaling,
   redundancy, and spatial/temporal contiguity reduce extraneous
   cognitive load; effect sizes for these are among the largest and most
   replicated in the instructional-design literature.
   <https://www.cambridge.org/core/books/abs/cambridge-handbook-of-multimedia-learning/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles/CD5B7AE1279A9AB81F8EEBB53DBEC86E>
4. Minimalism in technical communication (Carroll, *The Nürnberg
   Funnel*) — task-oriented instruction that supports real tasks
   immediately, and treats errors as something to recognise and recover
   from rather than prevent through exhaustive up-front explanation.
   <https://en.wikipedia.org/wiki/Minimalism_(technical_communication)>
5. The Diátaxis framework — documentation has four distinct modes
   (tutorial, how-to guide, reference, explanation), each meant to stay
   separate. <https://diataxis.fr/>
6. Expertise reversal effect (Kalyuga) — instructional support that
   helps a novice can have negative consequences for a more experienced
   learner reading the same material.
   <https://en.wikipedia.org/wiki/Expertise_reversal_effect>
7. The curse of knowledge, applied to documentation — writers
   overestimate what readers already know because their own fluency
   makes the material feel self-evident; independent review by someone
   matching the audience is the standard mitigation.
   <https://docsbydesign.com/2022/01/30/how-to-not-suffer-the-curse-of-knowledge/>
8. *Beyond Bullet Points* (Atkinson) — presentations built around a
   narrative arc (setup, complication, resolution) read more clearly
   than a flat list of topics. Practitioner source, not a peer-reviewed
   study — used here as a tiebreaker, not a hard rule.
   <https://www.microsoftpressstore.com/articles/article.aspx?p=2916274>
9. The testing effect (Roediger & Karpicke, 2006) — actively retrieving
   information produces better long-term retention than passive
   re-study or re-reading.
   <https://journals.sagepub.com/doi/10.1111/j.1467-9280.2006.01693.x>
10. Google Developer Documentation Style Guide — editorial guidelines
    for technical documentation, including tone, voice, and conciseness.
    <https://developers.google.com/style>

One heuristic above (artifact-vs-narration) reflects general
technical-writing practice rather than a specific verified study —
flagged here rather than attached to an uncertain citation.
