#!/usr/bin/env node
/**
 * The Forgotten Dungeon - A Text-Based Adventure Game
 */

const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Helper function to ask questions
function question(query) {
    return new Promise(resolve => rl.question(query, resolve));
}

// Helper function to sleep
function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Print text with typewriter effect
async function printSlow(text, delay = 10) {
    for (let char of text) {
        process.stdout.write(char);
        await sleep(delay);
    }
    console.log();
}

function printBanner() {
    const banner = `
    ╔═══════════════════════════════════════════╗
    ║    THE FORGOTTEN DUNGEON                  ║
    ║    A Text Adventure                       ║
    ╚═══════════════════════════════════════════╝
    `;
    console.log(banner);
}

class Player {
    constructor(name) {
        this.name = name;
        this.health = 100;
        this.inventory = [];
        this.gold = 20;
        this.criticalHits = 0;
        this.goblinsDefeated = 0;
        this.floor = 1;
        this.roomsExplored = 0;
    }

    addItem(item) {
        this.inventory.push(item);
        console.log(`\n✓ Added ${item} to inventory!`);
    }

    showStats() {
        // Show player character with equipment
        let weapon = '👊';
        if (this.inventory.includes('Silver Sword')) weapon = '⚔️';
        else if (this.inventory.includes('Golden Dagger')) weapon = '🗡️';
        else if (this.inventory.includes('Rusty Dagger')) weapon = '🔪';

        const hasAmulet = this.inventory.includes('Ancient Amulet') ? '💎' : '  ';

        console.log(`
    ╔═══════════════════════════════════════╗
    ║      ${weapon}  ${this.name.toUpperCase()}  ${hasAmulet}              ║
    ╠═══════════════════════════════════════╣
    ║         🧑                            ║
    ║        /|\\                           ║
    ║       / | \\     HP: ${this.health}/100         ║
    ║        / \\      Gold: ${this.gold}💰          ║
    ║                                       ║
    ║   Floor ${this.floor} | Rooms: ${this.roomsExplored}              ║`);
        if (this.inventory.length > 0) {
            console.log(`    ║   Items: ${this.inventory.join(', ')}`);
        }
        if (this.goblinsDefeated > 0) console.log(`    ║   Goblins Defeated: ${this.goblinsDefeated} 💀`);
        if (this.criticalHits > 0) console.log(`    ║   Critical Hits: ${this.criticalHits} 💥`);
        console.log(`    ╚═══════════════════════════════════════╝`);
    }
}

async function startGame() {
    printBanner();
    await printSlow("\nWelcome, brave adventurer!");

    let name = await question("\nWhat is your name? ");
    name = name.trim() || "Hero";

    const player = new Player(name);
    await printSlow(`\nGreetings, ${player.name}! Your adventure begins...\n`);
    await sleep(1000);

    await entrance(player);
}

async function entrance(player) {
    console.log(`
    ╔════════════════════════════════════════╗
    ║     🏰  DUNGEON ENTRANCE  🏰          ║
    ╠════════════════════════════════════════╣
    ║   _______________                      ║
    ║  |  _________  |]     ~~~~  ☁         ║
    ║  | |  .  .  | |      ~~~~~~            ║
    ║  | |    o   | |     ~~~~~~~~           ║
    ║  | |__\\_/__| |   ============          ║
    ║  |___________|  |            |         ║
    ║                 |    MOSS    |         ║
    ╚════════════════════════════════════════╝
    `);
    await printSlow("\nYou stand before the entrance of a dark, forgotten dungeon.");
    await printSlow("Moss covers the ancient stone walls, and a cold wind blows from within.");
    await printSlow("A rusty iron gate blocks your path, but it's slightly ajar...");

    console.log("\nWhat do you do?");
    console.log("1. Enter the dungeon");
    console.log("2. Search around the entrance");
    console.log("3. Leave (End game)");

    const choice = await question("\nChoice (1-3): ");

    switch (choice.trim()) {
        case "1":
            await firstChamber(player);
            break;
        case "2":
            const findChance = Math.random();
            if (findChance > 0.7) {
                await printSlow("\nYou search around the entrance and find a SHINY GOLDEN DAGGER hidden in the bushes!");
                await printSlow("This looks way better than a rusty one!");
                player.addItem("Golden Dagger");
                player.gold += 5;
            } else if (findChance > 0.3) {
                await printSlow("\nYou search around the entrance and find a rusty dagger hidden in the bushes!");
                player.addItem("Rusty Dagger");
            } else {
                await printSlow("\nYou search around but only find a confused squirrel.");
                await printSlow("The squirrel chatters at you angrily and runs away.");
                await printSlow("\n...Wait, was that squirrel carrying a tiny sword?");
            }
            player.showStats();
            await sleep(1000);
            await entrance(player);
            break;
        case "3":
            await printSlow(`\n${player.name} decided discretion was the better part of valor and left.`);
            await printSlow("Game Over!");
            return;
        default:
            console.log("\nInvalid choice. Try again.");
            await entrance(player);
    }
}

async function firstChamber(player) {
    console.log(`
    ╔═══════════════════════════════════════════════════╗
    ║            🕯️  MAIN CHAMBER  🕯️                  ║
    ╠═══════════════════════════════════════════════════╣
    ║                                                   ║
    ║   [💎 BLUE]      [💀 DARK]      [💧 WATER]       ║
    ║      ╱╲            ╱╲            ╱╲              ║
    ║     ╱  ╲          ╱  ╲          ╱  ╲             ║
    ║    ╱    ╲        ╱    ╲        ╱    ╲            ║
    ║   ╱ ✨  ╲      ╱ ███  ╲      ╱ 〰️  ╲          ║
    ║          🧍 YOU ARE HERE                         ║
    ╚═══════════════════════════════════════════════════╝
    `);
    await printSlow("\nYou push through the gate and enter a large, dimly lit chamber.");
    await printSlow("Three tunnels branch off from this room:");
    await printSlow("  - The LEFT tunnel glows with a faint blue light");
    await printSlow("  - The MIDDLE tunnel is pitch black");
    await printSlow("  - The RIGHT tunnel echoes with dripping water");

    console.log("\nWhich tunnel do you take?");
    console.log("1. Left tunnel (blue light)");
    console.log("2. Middle tunnel (darkness)");
    console.log("3. Right tunnel (water sounds)");
    console.log("4. Check your stats");

    const choice = await question("\nChoice (1-4): ");

    switch (choice.trim()) {
        case "1":
            await treasureRoom(player);
            break;
        case "2":
            await monsterEncounter(player);
            break;
        case "3":
            await undergroundLake(player);
            break;
        case "4":
            player.showStats();
            await firstChamber(player);
            break;
        default:
            console.log("\nInvalid choice. Try again.");
            await firstChamber(player);
    }
}

async function treasureRoom(player) {
    player.roomsExplored++;
    await printSlow("\nThe blue light grows brighter as you walk down the tunnel.");

    // Animated treasure room
    console.log(`
    ╔═════════════════════════════════════════════════╗
    ║          💎 TREASURE CHAMBER 💎                 ║
    ╠═════════════════════════════════════════════════╣
    ║    ✨  ⚱️         📦            🏺  ✨         ║
    ║                                                 ║
    ║       💰💰💰      ⚔️  SWORD      💰💰          ║
    ║     💰💰💰💰💰      HERE!      💰💰💰          ║
    ║       💰💰💰                    💰💰            ║
    ║                                                 ║
    ║    🪙  Coins scattered everywhere!  🪙         ║
    ╚═════════════════════════════════════════════════╝
    `);
    await sleep(300);
    await printSlow("You emerge into a small chamber filled with scattered coins and old chests!");

    const treasure = Math.floor(Math.random() * 21) + 10; // 10-30
    player.gold += treasure;
    await printSlow(`\n💰 You collected ${treasure} gold!`);

    // Random bonus treasure!
    if (Math.random() > 0.6) {
        const bonus = Math.floor(Math.random() * 20) + 10;
        await printSlow(`\n✨ You found a secret compartment with ${bonus} more gold!`);
        player.gold += bonus;
    }

    await printSlow("\nIn the corner, you spot a gleaming silver sword!");

    console.log("\nWhat do you do?");
    console.log("1. Take the sword");
    console.log("2. Leave the sword and exit");

    const choice = await question("\nChoice (1-2): ");

    if (choice.trim() === "1") {
        await printSlow("\nAs you grab the sword, the room begins to shake!");
        console.log(`
        ⚡ ⚔️  TAKING SWORD ⚔️ ⚡
        `);
        await sleep(500);
        if (player.inventory.includes("Rusty Dagger")) {
            await printSlow("You throw the rusty dagger at the mechanism and jam it!");
            console.log(`\n           🔪 → ⚙️  CLANK!\n`);
            await sleep(300);
            player.addItem("Silver Sword");
            await printSlow("You escape with the treasure!");
        } else {
            await printSlow("Rocks fall from the ceiling!");
            player.health -= 20;
            await printSlow(`You take 20 damage! Health: ${player.health}/100`);
            if (player.health > 0) {
                player.addItem("Silver Sword");
                await printSlow("But you managed to escape with the sword!");
            }
        }
    }

    player.showStats();
    await sleep(1000);

    if (player.health > 0) {
        await finalChoice(player);
    } else {
        await gameOver(player);
    }
}

async function monsterEncounter(player) {
    player.roomsExplored++;
    await printSlow("\nYou venture into the darkness...");

    // Special encounters!
    const specialEncounter = Math.random();

    if (specialEncounter > 0.95) {
        await printSlow("Suddenly, a FRIENDLY GOBLIN appears!");
        console.log(`
    👑  /\___/\\
       ( ^.^ )
        > ❤ <
       /|   |\\
      (_|   |_)
        `);
        await printSlow("\"Hello friend! I'm tired of fighting. Want to trade?\"");
        console.log("\n1. Trade 20 gold for a health potion");
        console.log("2. Trade 30 gold for a treasure map");
        console.log("3. Just chat");

        const choice = await question("\nChoice (1-3): ");
        if (choice.trim() === "1" && player.gold >= 20) {
            player.gold -= 20;
            player.health = Math.min(100, player.health + 40);
            await printSlow("\nThe goblin gives you a potion! +40 HP!");
        } else if (choice.trim() === "2" && player.gold >= 30) {
            player.gold -= 30;
            player.gold += 75;
            await printSlow("\nThe map leads to hidden treasure! +75 gold!");
        } else if (choice.trim() === "3") {
            await printSlow("\nThe goblin tells you a joke. It's terrible.");
            await printSlow("But you both laugh anyway. +10 HP from good vibes!");
            player.health = Math.min(100, player.health + 10);
        } else {
            await printSlow("\nThe goblin waves goodbye and disappears.");
        }
        player.showStats();
        await sleep(1000);
        await finalChoice(player);
        return;
    }

    const numGoblins = Math.floor(Math.random() * 5) + 1; // 1-5 goblins (balanced)
    const goblinText = numGoblins === 1 ? "a GOBLIN" : `${numGoblins} GOBLINS`;
    const goblinScreech = numGoblins === 1 ? "'Your gold or your life!' it screeches." : "'Your gold or your lives!' they screech.";

    await printSlow(`Suddenly, ${goblinText} jump${numGoblins === 1 ? 's' : ''} out from the shadows!`);

    // Display goblin ASCII art based on number
    if (numGoblins === 1) {
        console.log(`
    ⚔️  /\\___/\\
       ( o.o )
        > ^ <
       /|   |\\
      (_|   |_)
        `);
    } else if (numGoblins <= 3) {
        console.log(`
    ⚔️  /\\___/\\    /\\___/\\    /\\___/\\
       ( o.o )  ( >.<)   ( o.o )
        > ^ <    > ^ <    > ^ <
       /|   |\\  /|   |\\  /|   |\\
      (_|   |_)(_|   |_)(_|   |_)
        `);
    } else if (numGoblins <= 5) {
        console.log(`
    ⚔️  /\\___/\\  /\\___/\\  /\\___/\\  /\\___/\\  /\\___/\\
       ( o.o ) ( >.<)  ( o.o ) ( @.@)  ( o.o )
        > ^ <   > ^ <   > ^ <   > ^ <   > ^ <
       /|   |\\ /|   |\\ /|   |\\ /|   |\\ /|   |\\
      (_|   |_|_|   |_|_|   |_|_|   |_|_|   |_)
        `);
    } else {
        console.log(`
    ⚔️  GOBLIN HORDE!
    
       /\\___/\\  /\\___/\\  /\\___/\\  /\\___/\\  /\\___/\\  /\\___/\\  /\\___/\\
      ( o.o ) ( >.<)  ( o.o ) ( @.@)  ( o.o ) ( x.x)  ( o.o )
       > ^ <   > ^ <   > ^ <   > ^ <   > ^ <   > ^ <   > ^ <
      /|   |\\ /|   |\\ /|   |\\ /|   |\\ /|   |\\ /|   |\\ /|   |\\
     (_|   |_|_|   |_|_|   |_|_|   |_|_|   |_|_|   |_|_|   |_)
        `);
    }

    await printSlow(`🗡️  ${goblinScreech}`);

    console.log("\nWhat do you do?");
    console.log("1. Fight the goblin" + (numGoblins > 1 ? "s" : ""));
    console.log(`2. Offer gold (${10 * numGoblins} gold)`);
    console.log("3. Try to run");

    const choice = await question("\nChoice (1-3): ");

    switch (choice.trim()) {
        case "1":
            if (player.inventory.includes("Golden Dagger") || player.inventory.includes("Silver Sword")) {
                await printSlow("\nYou draw your legendary weapon and strike!");
                const critChance = Math.random();
                if (critChance > 0.7) {
                    await printSlow("💥 CRITICAL HIT! Your blade glows with power!");
                    player.criticalHits++;
                }
                await printSlow(`The goblin${numGoblins === 1 ? '' : 's'} fall${numGoblins === 1 ? 's' : ''} defeated!`);
                const loot = (Math.floor(Math.random() * 11) + 15) * numGoblins;
                player.gold += loot;
                player.goblinsDefeated += numGoblins;
                await printSlow(`💰 You found ${loot} gold on the goblin${numGoblins === 1 ? '' : 's'}!`);

                if (player.goblinsDefeated >= 10) {
                    await printSlow("\n🏆 Achievement Unlocked: Goblin Slayer!");
                }
            } else if (player.inventory.includes("Rusty Dagger")) {
                await printSlow("\nYou draw your rusty dagger and fight!");
                const damage = Math.min(15 * numGoblins, 40); // Cap damage
                player.health -= damage;
                await printSlow(`You defeat them but take ${damage} damage! Health: ${player.health}/100`);
                const loot = (Math.floor(Math.random() * 11) + 15) * numGoblins;
                player.gold += loot;
                player.goblinsDefeated += numGoblins;
                await printSlow(`💰 You found ${loot} gold!`);
            } else {
                await printSlow("\nYou fight with your bare hands!");
                const luckyPunch = Math.random();
                if (luckyPunch > 0.85) {
                    await printSlow("🥊 AMAZING! You land a legendary punch!");
                    await printSlow(`The goblin${numGoblins === 1 ? '' : 's'} scatter${numGoblins === 1 ? 's' : ''} in fear!`);
                    player.criticalHits++;
                    player.goblinsDefeated += numGoblins;
                    const loot = Math.floor(Math.random() * 20) + 10;
                    player.gold += loot;
                    await printSlow(`💰 You found ${loot} gold they dropped!`);
                } else {
                    const damage = Math.min(20 * numGoblins, 60); // Cap damage so it's survivable
                    player.health -= damage;
                    await printSlow(`You take ${damage} damage in the fight! Health: ${player.health}/100`);
                    if (player.health > 0) {
                        await printSlow("You manage to drive them off!");
                        player.goblinsDefeated += numGoblins;
                    }
                }
            }
            break;
        case "2":
            const goldRequired = 10 * numGoblins;
            if (player.gold >= goldRequired) {
                player.gold -= goldRequired;
                await printSlow(`\nThe goblin${numGoblins === 1 ? '' : 's'} take${numGoblins === 1 ? 's' : ''} your gold and scurries away.`);
            } else {
                await printSlow(`\nYou don't have enough gold! The goblin${numGoblins === 1 ? '' : 's'} attack${numGoblins === 1 ? 's' : ''}!`);
                player.health -= 25 * numGoblins;
                await printSlow(`Health: ${player.health}/100`);
            }
            break;
        case "3":
            if (Math.random() > 0.3) {
                await printSlow("\nYou successfully escape back to the main chamber!");
                await firstChamber(player);
                return;
            } else {
                await printSlow(`\nThe goblin${numGoblins === 1 ? '' : 's'} catch${numGoblins === 1 ? 'es' : ''} you and strike${numGoblins === 1 ? 's' : ''} your back!`);
                player.health -= 15 * numGoblins;
                await printSlow(`Health: ${player.health}/100`);
            }
            break;
    }

    player.showStats();
    await sleep(1000);

    if (player.health > 0) {
        await finalChoice(player);
    } else {
        await gameOver(player);
    }
}

async function undergroundLake(player) {
    player.roomsExplored++;
    await printSlow("\nYou follow the sound of dripping water...");

    // Animated lake
    console.log(`
    ╔═══════════════════════════════════════════════════╗
    ║         🌊 UNDERGROUND LAKE 🌊                    ║
    ╠═══════════════════════════════════════════════════╣
    ║   🕯️                                     🕯️       ║
    ║        ___________________________                ║
    ║       /  ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈  \\              ║
    ║      /  ≈≈🐟≈≈≈✨≈≈≈≈≈≈🐠≈≈≈≈≈  \\             ║
    ║     |  ≈≈≈≈≈≈≈≈💎≈≈≈≈≈≈≈≈≈≈≈≈≈  |            ║
    ║     |  ≈≈≈≈✨≈≈≈≈≈≈🐟≈≈≈≈✨≈≈  |            ║
    ║      \\  ≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈  /             ║
    ║       \\_________________________/                ║
    ║             Bioluminescent glow ✨               ║
    ╚═══════════════════════════════════════════════════╝
    `);
    await sleep(300);
    await printSlow("The tunnel opens into a cavern with a beautiful underground lake.");
    await printSlow("The water sparkles with bioluminescent algae.");
    await printSlow("\nYou notice something glinting at the bottom of the lake.");

    console.log("\nWhat do you do?");
    console.log("1. Dive in to retrieve the object");
    console.log("2. Drink the water (restore health)");
    console.log("3. Continue exploring");

    const choice = await question("\nChoice (1-3): ");

    switch (choice.trim()) {
        case "1":
            await printSlow("\nYou dive into the cold water and retrieve an ancient amulet!");
            player.addItem("Ancient Amulet");
            await printSlow("You feel a surge of energy!");
            player.health = Math.min(100, player.health + 30);

            if (Math.random() > 0.5) {
                await printSlow("\n🐠 A friendly glowing fish swims by and drops a pearl!");
                player.gold += 25;
                await printSlow("+25 gold!");
            }
            break;
        case "2":
            await printSlow("\nYou drink the crystal-clear water.");
            const heal = Math.floor(Math.random() * 11) + 15; // 15-25
            player.health = Math.min(100, player.health + heal);
            await printSlow(`You feel AMAZING! Restored ${heal} health.`);

            if (Math.random() > 0.7) {
                await printSlow("The water has magical properties! You feel stronger!");
                await printSlow("✨ Maximum health increased to 120!");
                player.health = 120;
            }
            break;
        case "3":
            if (Math.random() > 0.7) {
                await printSlow("\nAs you turn to leave, you notice a glowing inscription on the wall.");
                await printSlow("It reads: 'The brave find fortune.' A secret door opens!");
                player.gold += 30;
                await printSlow("💰 +30 gold from the secret cache!");
            }
            break;
    }

    player.showStats();
    await sleep(1000);
    await finalChoice(player);
}

async function finalChoice(player) {
    await printSlow("\n" + "=".repeat(50));
    await printSlow("You've explored this area of the dungeon.");
    await printSlow("You see multiple paths ahead...");

    console.log("\nWhat do you do?");
    console.log("1. Explore more rooms on this floor");
    console.log("2. Descend to the next floor");
    console.log("3. Rest and heal (costs 10 gold)");
    console.log("4. Check stats");
    console.log("5. Exit the dungeon (End game)");

    const choice = await question("\nChoice (1-5): ");

    switch (choice.trim()) {
        case "1":
            await printSlow("\nYou continue exploring...");
            await sleep(500);
            await firstChamber(player);
            break;
        case "2":
            player.floor++;
            console.log(`
    ╔═══════════════════════════════════════╗
    ║      DESCENDING TO FLOOR ${player.floor}...      ║
    ╠═══════════════════════════════════════╣
    ║                                       ║
    ║         🧑     Going down...         ║
    ║        /|\\                           ║
    ║        / \\    ↓ ↓ ↓                 ║
    ║                                       ║
    ║         🧑                           ║
    ║        /|\\     ↓ ↓ ↓                ║
    ║        / \\                           ║
    ║                                       ║
    ╚═══════════════════════════════════════╝
            `);
            await sleep(800);
            await printSlow(`\nWelcome to Floor ${player.floor}!`);

            if (player.floor % 5 === 0) {
                await printSlow("\n⚠️  This floor feels different... more dangerous!");
                await printSlow("🎁 But you found a care package! +50 HP and +30 Gold!");
                player.health = Math.min(100, player.health + 50);
                player.gold += 30;
            }

            await sleep(1000);
            await firstChamber(player);
            break;
        case "3":
            if (player.gold >= 10) {
                player.gold -= 10;
                const healing = Math.floor(Math.random() * 21) + 20; // 20-40 HP
                player.health = Math.min(100, player.health + healing);
                await printSlow(`\n💤 You rest and recover ${healing} HP.`);
                await sleep(1000);
                await finalChoice(player);
            } else {
                await printSlow("\n❌ Not enough gold to rest!");
                await sleep(1000);
                await finalChoice(player);
            }
            break;
        case "4":
            player.showStats();
            await finalChoice(player);
            break;
        case "5":
            await victory(player);
            break;
        default:
            console.log("\nInvalid choice. Try again.");
            await finalChoice(player);
    }
}

async function victory(player) {
    console.log(`
    ╔═══════════════════════════════════════════════════╗
    ║         🎉 CONGRATULATIONS! 🎉                    ║
    ╠═══════════════════════════════════════════════════╣
    ║                                                   ║
    ║              ⭐  VICTORY!  ⭐                      ║
    ║                                                   ║
    ║           🏆                    🏆                ║
    ║              \\      🧑      /                     ║
    ║               \\    /|\\    /                      ║
    ║                \\   / \\   /                       ║
    ║                 ☀️  YOU  ☀️                       ║
    ║                                                   ║
    ║           ESCAPED THE DUNGEON!                   ║
    ╚═══════════════════════════════════════════════════╝
    `);
    await printSlow(`\n${player.name} emerges from the dungeon victorious!`);
    player.showStats();

    // Calculate score
    const score = player.gold + (player.health * 2) + (player.inventory.length * 15) + (player.goblinsDefeated * 5) + (player.criticalHits * 10) + (player.floor * 20) + (player.roomsExplored * 3);
    await printSlow(`\nFinal Score: ${score}`);

    await printSlow(`\n📊 Stats Breakdown:`);
    await printSlow(`   Floors Explored: ${player.floor}`);
    await printSlow(`   Rooms Explored: ${player.roomsExplored}`);
    await printSlow(`   Gold: ${player.gold}`);
    await printSlow(`   Health: ${player.health}`);
    await printSlow(`   Items: ${player.inventory.length}`);
    await printSlow(`   Goblins Defeated: ${player.goblinsDefeated}`);
    await printSlow(`   Critical Hits: ${player.criticalHits}`);

    if (score > 300) {
        await printSlow("\n🏆 Rank: LEGENDARY HERO!");
        await printSlow("Songs will be sung of your adventures!");
    } else if (score > 200) {
        await printSlow("\n⭐ Rank: Master Adventurer!");
        await printSlow("You've proven yourself a true dungeon crawler!");
    } else if (score > 150) {
        await printSlow("\n✨ Rank: Skilled Explorer");
        await printSlow("Not bad at all!");
    } else if (score > 100) {
        await printSlow("\n🎖️ Rank: Capable Adventurer");
        await printSlow("You know your way around a dungeon!");
    } else if (score > 50) {
        await printSlow("\n🗡️ Rank: Novice Adventurer");
        await printSlow("A decent first run!");
    } else {
        await printSlow("\n🍀 Rank: Lucky Survivor");
        await printSlow("Hey, you made it out alive!");
    }

    await printSlow("\nThanks for playing!");
}

async function gameOver(player) {
    console.log(`
    ╔═══════════════════════════════════════════════════╗
    ║              💀 GAME OVER 💀                      ║
    ╠═══════════════════════════════════════════════════╣
    ║                                                   ║
    ║              👻  R.I.P  👻                        ║
    ║                                                   ║
    ║            _______________                        ║
    ║           |               |                       ║
    ║           |   ${player.name}        |                       ║
    ║           |               |                       ║
    ║           |  Floor ${player.floor}     |                       ║
    ║           |_______________|                       ║
    ║              |         |                          ║
    ║           ===|=========|===                       ║
    ║                                                   ║
    ╚═══════════════════════════════════════════════════╝
    `);
    await printSlow(`\n${player.name} has fallen in the dungeon...`);
    await printSlow("Your adventure ends here.");
    await printSlow("\nThanks for playing!");
}

async function main() {
    while (true) {
        await startGame();
        console.log("\n" + "=".repeat(50));
        const again = await question("\nPlay again? (yes/no): ");
        if (!['yes', 'y'].includes(again.trim().toLowerCase())) {
            console.log("\nFarewell, adventurer!");
            rl.close();
            break;
        }
    }
}

main().catch(err => {
    console.error("An error occurred:", err);
    rl.close();
});
