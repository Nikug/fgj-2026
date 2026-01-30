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
async function printSlow(text, delay = 30) {
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
        this.gold = 10;
    }

    addItem(item) {
        this.inventory.push(item);
        console.log(`\n✓ Added ${item} to inventory!`);
    }

    showStats() {
        console.log(`\n--- ${this.name}'s Stats ---`);
        console.log(`Health: ${this.health}/100`);
        console.log(`Gold: ${this.gold}`);
        console.log(`Inventory: ${this.inventory.length > 0 ? this.inventory.join(', ') : 'Empty'}`);
        console.log('------------------------');
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
            await printSlow("\nYou search around the entrance and find a rusty dagger hidden in the bushes!");
            player.addItem("Rusty Dagger");
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
    await printSlow("\nThe blue light grows brighter as you walk down the tunnel.");
    await printSlow("You emerge into a small chamber filled with scattered coins and old chests!");

    const treasure = Math.floor(Math.random() * 21) + 10; // 10-30
    player.gold += treasure;
    await printSlow(`\n💰 You collected ${treasure} gold!`);

    await printSlow("\nIn the corner, you spot a gleaming silver sword!");

    console.log("\nWhat do you do?");
    console.log("1. Take the sword");
    console.log("2. Leave the sword and exit");

    const choice = await question("\nChoice (1-2): ");

    if (choice.trim() === "1") {
        await printSlow("\nAs you grab the sword, the room begins to shake!");
        if (player.inventory.includes("Rusty Dagger")) {
            await printSlow("You throw the rusty dagger at the mechanism and jam it!");
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
    await printSlow("\nYou venture into the darkness...");
    await printSlow("Suddenly, a GOBLIN jumps out from the shadows!");
    await printSlow("🗡️  'Your gold or your life!' it screeches.");

    console.log("\nWhat do you do?");
    console.log("1. Fight the goblin");
    console.log("2. Offer gold (10 gold)");
    console.log("3. Try to run");

    const choice = await question("\nChoice (1-3): ");

    switch (choice.trim()) {
        case "1":
            if (player.inventory.includes("Rusty Dagger") || player.inventory.includes("Silver Sword")) {
                await printSlow("\nYou draw your weapon and strike!");
                await printSlow("The goblin falls defeated!");
                const loot = Math.floor(Math.random() * 11) + 15; // 15-25
                player.gold += loot;
                await printSlow(`💰 You found ${loot} gold on the goblin!`);
            } else {
                await printSlow("\nYou fight with your bare hands!");
                if (Math.random() > 0.5) {
                    await printSlow("You manage to defeat the goblin, but you're badly wounded!");
                    player.health -= 30;
                    await printSlow(`Health: ${player.health}/100`);
                } else {
                    await printSlow("The goblin overpowers you!");
                    player.health -= 50;
                    await printSlow(`Health: ${player.health}/100`);
                }
            }
            break;
        case "2":
            if (player.gold >= 10) {
                player.gold -= 10;
                await printSlow("\nThe goblin takes your gold and scurries away.");
            } else {
                await printSlow("\nYou don't have enough gold! The goblin attacks!");
                player.health -= 25;
                await printSlow(`Health: ${player.health}/100`);
            }
            break;
        case "3":
            if (Math.random() > 0.3) {
                await printSlow("\nYou successfully escape back to the main chamber!");
                await firstChamber(player);
                return;
            } else {
                await printSlow("\nThe goblin catches you and strikes your back!");
                player.health -= 15;
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
    await printSlow("\nYou follow the sound of dripping water...");
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
            player.health = Math.min(100, player.health + 25);
            break;
        case "2":
            await printSlow("\nYou drink the crystal-clear water.");
            const heal = Math.floor(Math.random() * 11) + 10; // 10-20
            player.health = Math.min(100, player.health + heal);
            await printSlow(`You feel refreshed! Restored ${heal} health.`);
            break;
    }

    player.showStats();
    await sleep(1000);
    await finalChoice(player);
}

async function finalChoice(player) {
    await printSlow("\n" + "=".repeat(50));
    await printSlow("You've explored the dungeon and gathered your treasures.");
    await printSlow("Ahead, you see stairs leading deeper into the dungeon...");
    await printSlow("But you also notice the exit isn't far.");

    console.log("\nWhat do you do?");
    console.log("1. Descend deeper (Continue adventure)");
    console.log("2. Exit the dungeon (End game)");
    console.log("3. Check stats");

    const choice = await question("\nChoice (1-3): ");

    switch (choice.trim()) {
        case "1":
            await printSlow("\nYou bravely descend the stairs...");
            await printSlow("The adventure continues...");
            await printSlow("\n[To be continued in future updates!]");
            await victory(player);
            break;
        case "2":
            await victory(player);
            break;
        case "3":
            player.showStats();
            await finalChoice(player);
            break;
        default:
            console.log("\nInvalid choice. Try again.");
            await finalChoice(player);
    }
}

async function victory(player) {
    await printSlow("\n" + "=".repeat(50));
    await printSlow("🎉 CONGRATULATIONS! 🎉");
    await printSlow(`\n${player.name} emerges from the dungeon victorious!`);
    player.showStats();

    // Calculate score
    const score = player.gold + (player.health * 2) + (player.inventory.length * 10);
    await printSlow(`\nFinal Score: ${score}`);

    if (score > 150) {
        await printSlow("Rank: LEGENDARY ADVENTURER!");
    } else if (score > 100) {
        await printSlow("Rank: Expert Explorer");
    } else if (score > 50) {
        await printSlow("Rank: Novice Adventurer");
    } else {
        await printSlow("Rank: Lucky Survivor");
    }

    await printSlow("\nThanks for playing!");
}

async function gameOver(player) {
    await printSlow("\n" + "=".repeat(50));
    await printSlow("💀 GAME OVER 💀");
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
