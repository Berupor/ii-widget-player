.pragma library

/** The player up front: the one picked by hand, else the shell's active one, else whatever plays. */
function pick(picked, active, players) {
    return [picked, active].find(p => p && players.includes(p))
        ?? players.find(p => p.isPlaying) ?? players[0] ?? null
}
