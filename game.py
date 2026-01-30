#!/usr/bin/env python3
"""
The Forgotten Dungeon - A Text-Based Adventure Game
"""

import random
import time

def print_slow(text, delay=0.03):
    """Print text with a typewriter effect"""
    for char in text:
        print(char, end='', flush=True)
        time.sleep(delay)
    print()

def print_banner():
    """Display game banner"""
    banner = """
    ╔═══════════════════════════════════════════╗
    ║    THE FORGOTTEN DUNGEON                  ║
    ║    A Text Adventure                       ║
    ╚═══════════════════════════════════════════╝
    """
    print(banner)

class Player:
    def __init__(self, name):
        self.name = name
        self.health = 100
        self.inventory = []
        self.gold = 10
        
    def add_item(self, item):
        self.inventory.append(item)
        print(f"\n✓ Added {item} to inventory!")
        
    def show_stats(self):
        print(f"\n--- {self.name}'s Stats ---")
        print(f"Health: {self.health}/100")
        print(f"Gold: {self.gold}")
        print(f"Inventory: {', '.join(self.inventory) if self.inventory else 'Empty'}")
        print("------------------------")

def start_game():
    """Initialize and start the game"""
    print_banner()
    print_slow("\nWelcome, brave adventurer!")
    name = input("\nWhat is your name? ").strip()
    if not name:
        name = "Hero"
    
    player = Player(name)
    print_slow(f"\nGreetings, {player.name}! Your adventure begins...\n")
    time.sleep(1)
    
    entrance(player)

def entrance(player):
    """The entrance to the dungeon"""
    print_slow("\nYou stand before the entrance of a dark, forgotten dungeon.")
    print_slow("Moss covers the ancient stone walls, and a cold wind blows from within.")
    print_slow("A rusty iron gate blocks your path, but it's slightly ajar...")
    
    print("\nWhat do you do?")
    print("1. Enter the dungeon")
    print("2. Search around the entrance")
    print("3. Leave (End game)")
    
    choice = input("\nChoice (1-3): ").strip()
    
    if choice == "1":
        first_chamber(player)
    elif choice == "2":
        print_slow("\nYou search around the entrance and find a rusty dagger hidden in the bushes!")
        player.add_item("Rusty Dagger")
        player.show_stats()
        time.sleep(1)
        entrance(player)
    elif choice == "3":
        print_slow(f"\n{player.name} decided discretion was the better part of valor and left.")
        print_slow("Game Over!")
        return
    else:
        print("\nInvalid choice. Try again.")
        entrance(player)

def first_chamber(player):
    """The first chamber in the dungeon"""
    print_slow("\nYou push through the gate and enter a large, dimly lit chamber.")
    print_slow("Three tunnels branch off from this room:")
    print_slow("  - The LEFT tunnel glows with a faint blue light")
    print_slow("  - The MIDDLE tunnel is pitch black")
    print_slow("  - The RIGHT tunnel echoes with dripping water")
    
    print("\nWhich tunnel do you take?")
    print("1. Left tunnel (blue light)")
    print("2. Middle tunnel (darkness)")
    print("3. Right tunnel (water sounds)")
    print("4. Check your stats")
    
    choice = input("\nChoice (1-4): ").strip()
    
    if choice == "1":
        treasure_room(player)
    elif choice == "2":
        monster_encounter(player)
    elif choice == "3":
        underground_lake(player)
    elif choice == "4":
        player.show_stats()
        first_chamber(player)
    else:
        print("\nInvalid choice. Try again.")
        first_chamber(player)

def treasure_room(player):
    """A room with treasure"""
    print_slow("\nThe blue light grows brighter as you walk down the tunnel.")
    print_slow("You emerge into a small chamber filled with scattered coins and old chests!")
    
    treasure = random.randint(10, 30)
    player.gold += treasure
    print_slow(f"\n💰 You collected {treasure} gold!")
    
    print_slow("\nIn the corner, you spot a gleaming silver sword!")
    
    print("\nWhat do you do?")
    print("1. Take the sword")
    print("2. Leave the sword and exit")
    
    choice = input("\nChoice (1-2): ").strip()
    
    if choice == "1":
        print_slow("\nAs you grab the sword, the room begins to shake!")
        if "Rusty Dagger" in player.inventory:
            print_slow("You throw the rusty dagger at the mechanism and jam it!")
            player.add_item("Silver Sword")
            print_slow("You escape with the treasure!")
        else:
            print_slow("Rocks fall from the ceiling!")
            player.health -= 20
            print_slow(f"You take 20 damage! Health: {player.health}/100")
            if player.health > 0:
                player.add_item("Silver Sword")
                print_slow("But you managed to escape with the sword!")
        
    player.show_stats()
    time.sleep(1)
    
    if player.health > 0:
        final_choice(player)
    else:
        game_over(player)

def monster_encounter(player):
    """Encounter with a goblin"""
    print_slow("\nYou venture into the darkness...")
    print_slow("Suddenly, a GOBLIN jumps out from the shadows!")
    print_slow("🗡️  'Your gold or your life!' it screeches.")
    
    print("\nWhat do you do?")
    print("1. Fight the goblin")
    print("2. Offer gold (10 gold)")
    print("3. Try to run")
    
    choice = input("\nChoice (1-3): ").strip()
    
    if choice == "1":
        if "Rusty Dagger" in player.inventory or "Silver Sword" in player.inventory:
            print_slow("\nYou draw your weapon and strike!")
            print_slow("The goblin falls defeated!")
            loot = random.randint(15, 25)
            player.gold += loot
            print_slow(f"💰 You found {loot} gold on the goblin!")
        else:
            print_slow("\nYou fight with your bare hands!")
            if random.random() > 0.5:
                print_slow("You manage to defeat the goblin, but you're badly wounded!")
                player.health -= 30
                print_slow(f"Health: {player.health}/100")
            else:
                print_slow("The goblin overpowers you!")
                player.health -= 50
                print_slow(f"Health: {player.health}/100")
    elif choice == "2":
        if player.gold >= 10:
            player.gold -= 10
            print_slow("\nThe goblin takes your gold and scurries away.")
        else:
            print_slow("\nYou don't have enough gold! The goblin attacks!")
            player.health -= 25
            print_slow(f"Health: {player.health}/100")
    elif choice == "3":
        if random.random() > 0.3:
            print_slow("\nYou successfully escape back to the main chamber!")
            first_chamber(player)
            return
        else:
            print_slow("\nThe goblin catches you and strikes your back!")
            player.health -= 15
            print_slow(f"Health: {player.health}/100")
    
    player.show_stats()
    time.sleep(1)
    
    if player.health > 0:
        final_choice(player)
    else:
        game_over(player)

def underground_lake(player):
    """An underground lake"""
    print_slow("\nYou follow the sound of dripping water...")
    print_slow("The tunnel opens into a cavern with a beautiful underground lake.")
    print_slow("The water sparkles with bioluminescent algae.")
    print_slow("\nYou notice something glinting at the bottom of the lake.")
    
    print("\nWhat do you do?")
    print("1. Dive in to retrieve the object")
    print("2. Drink the water (restore health)")
    print("3. Continue exploring")
    
    choice = input("\nChoice (1-3): ").strip()
    
    if choice == "1":
        print_slow("\nYou dive into the cold water and retrieve an ancient amulet!")
        player.add_item("Ancient Amulet")
        print_slow("You feel a surge of energy!")
        player.health = min(100, player.health + 25)
    elif choice == "2":
        print_slow("\nYou drink the crystal-clear water.")
        heal = random.randint(10, 20)
        player.health = min(100, player.health + heal)
        print_slow(f"You feel refreshed! Restored {heal} health.")
    
    player.show_stats()
    time.sleep(1)
    final_choice(player)

def final_choice(player):
    """Final decision point"""
    print_slow("\n" + "="*50)
    print_slow("You've explored the dungeon and gathered your treasures.")
    print_slow("Ahead, you see stairs leading deeper into the dungeon...")
    print_slow("But you also notice the exit isn't far.")
    
    print("\nWhat do you do?")
    print("1. Descend deeper (Continue adventure)")
    print("2. Exit the dungeon (End game)")
    print("3. Check stats")
    
    choice = input("\nChoice (1-3): ").strip()
    
    if choice == "1":
        print_slow("\nYou bravely descend the stairs...")
        print_slow("The adventure continues...")
        print_slow("\n[To be continued in future updates!]")
        victory(player)
    elif choice == "2":
        victory(player)
    elif choice == "3":
        player.show_stats()
        final_choice(player)
    else:
        print("\nInvalid choice. Try again.")
        final_choice(player)

def victory(player):
    """Player wins"""
    print_slow("\n" + "="*50)
    print_slow("🎉 CONGRATULATIONS! 🎉")
    print_slow(f"\n{player.name} emerges from the dungeon victorious!")
    player.show_stats()
    
    # Calculate score
    score = player.gold + (player.health * 2) + (len(player.inventory) * 10)
    print_slow(f"\nFinal Score: {score}")
    
    if score > 150:
        print_slow("Rank: LEGENDARY ADVENTURER!")
    elif score > 100:
        print_slow("Rank: Expert Explorer")
    elif score > 50:
        print_slow("Rank: Novice Adventurer")
    else:
        print_slow("Rank: Lucky Survivor")
    
    print_slow("\nThanks for playing!")

def game_over(player):
    """Player dies"""
    print_slow("\n" + "="*50)
    print_slow("💀 GAME OVER 💀")
    print_slow(f"\n{player.name} has fallen in the dungeon...")
    print_slow("Your adventure ends here.")
    print_slow("\nThanks for playing!")

def main():
    """Main game loop"""
    while True:
        start_game()
        print("\n" + "="*50)
        again = input("\nPlay again? (yes/no): ").strip().lower()
        if again not in ['yes', 'y']:
            print("\nFarewell, adventurer!")
            break

if __name__ == "__main__":
    main()
