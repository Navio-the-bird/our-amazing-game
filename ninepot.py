from random import randrange, choice, shuffle

F_TANGY = 0
F_SWEET = 1
F_FIREY = 2
F_DICT = [F_FIREY, F_SWEET, F_TANGY]
shuffle(F_DICT)

S_LITTLE = 3
S_MODERA = 4
S_SPICY = 5
S_DICT = [S_SPICY, S_MODERA, S_LITTLE]
shuffle(S_DICT)

B_FLAT = 6
B_BUBBLY = 7
B_FIZZY = 8
B_DICT = [B_BUBBLY, B_FIZZY, B_FLAT]
shuffle(B_DICT)

C_BLUE = 0
C_RED = 1
C_GREEN = 2


def rand_bool() -> bool:
    return choice([True, False])

def get_name_from_num(i : int) -> str:
    match i:
        case 0: 
            return "Tangy"
        case 1: 
            return "Sweet"
        case 2: 
            return "Firey"
        
        case 3:
            return "Not spicy"
        case 4:
            return "Moderately spicy"
        case 5:
            return "Spicy"
        
        case 6:
            return "Flat"
        case 7:
            return "Bubbly"
        case 8:
            return "Fizzy"

        case default: 
            return "Hmm"

def gen_request() -> tuple[int, int, int]:
    print("[Customer request comes in...]")
    print("I would something that is...")

    b_ind, f_ind, s_ind = -1, -1, -1

    if(rand_bool()):
        b = choice([B_FLAT, B_FIZZY, B_BUBBLY])
        print(get_name_from_num(b) + "...")
        b_ind = [v for v in B_DICT if b == v][0]

    
    if(rand_bool()):
        f = choice([F_FIREY, F_SWEET, F_TANGY])
        print(get_name_from_num(f) + "...")
        f_ind = [v for v in F_DICT if f == v][0]
    
    if(rand_bool()):
        s = choice([S_LITTLE, S_MODERA, S_SPICY])
        print(get_name_from_num(s) + "...")
        s_ind = [v for v in S_DICT if s == v][0]

 
    print("Yeah that's it!")

    return (b_ind, f_ind, s_ind)

print(gen_request())

def cook(req : tuple[int, int, int]):
    """JESSE"""
    print("Cooking order: Buzz Flavour Spice")
    picked_ingredients : list[int] = []
    for _ in range(3):
        user_input = -1
        print("What ingredient would you like to add? (b, g, r)")
        while user_input == -1:
            raw_input = input()
            if(raw_input.lower() in "rgb"):
                match raw_input:
                    case "r":
                        user_input = C_RED
                    case "g":
                        user_input = C_GREEN
                    case "b":
                        user_input = C_BLUE
            picked_ingredients.append(user_input)
    

    if B_DICT[picked_ingredients[0]] == req[0]:
        print("Good buzz")
    else:
        print("Bad buzz")
    
    
    if F_DICT[picked_ingredients[1]] == req[1]:
        print("Good flavour")
    else:
        print("Bad flavour")
        
    if S_DICT[picked_ingredients[2]] == req[2]:
        print("Good spice")
    else:
        print("Bad spice")


while True:
    cook(gen_request())