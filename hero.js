.pragma library

/** The player up front: the one picked by hand, else the shell's active one, else whatever plays. */
function pick(picked, active, players) {
    return [picked, active].find(p => p && players.includes(p))
        ?? players.find(p => p.isPlaying) ?? players[0] ?? null
}

/** The list under the hero: `slots` order kept, players that came since appended. */
function rows(slots, hero, players) {
    const kept = slots.filter(p => p !== hero && players.includes(p))
    return [...kept, ...players.filter(p => p !== hero && !kept.includes(p))]
}

/** Slots after `picked` moves up: the old hero takes its place, so the other rows stay put. */
function swap(rows, picked, hero) {
    return rows.map(p => p === picked ? hero : p)
}

const tints = {}

/** The card color last taken from this cover: a reopened popup starts on it instead of fading in. */
function tintOf(url, fallback) {
    return tints[url] ?? fallback
}

function hasTint(url) {
    return url in tints
}

function rememberTint(url, color) {
    tints[url] = color
}

const fetched = {}

/** Covers already in the shell's cache: a reopened popup shows them at once instead of after a curl round trip. */
function isFetched(url) {
    return url in fetched
}

function rememberFetched(url) {
    fetched[url] = true
}
