class_name LootTable extends Resource

var loot_file = "./loottable/LootTable1.csv"

var raw_headers = []
var raw_header_index = {}
var raw_data = []

var loot_by_category = {}
var loot_items = []

func _init():
    print("Loot Table initializing...")
    loadTableFile()
    generate_table()
    print("Loot Tables populated.")

func loadTableFile():
    print_debug("Loading table file from " + loot_file)
    var file = FileAccess.open(loot_file, FileAccess.READ)
    var csv = []
    while !file.eof_reached():
        var csv_rows = file.get_csv_line(",")
        csv.append(csv_rows)
    file.close()

    csv.pop_back()  # Removes blank line from end
    raw_headers = Array(csv[0])
    raw_data = csv          # Grab headers
    raw_data.pop_front()    # Remove headers from data
    raw_header_index = {}   
    for i in raw_headers.size():    # Building a header index for easy lookup later
        raw_header_index[raw_headers[i]] = i

func generate_table():
    for row in raw_data:
        # Create a new loot item and populate it
        var loot_item = LootItem.new()
        loot_item.id = row[raw_header_index["ID"]].to_int()
        loot_item.name = row[raw_header_index["Name"]]
        loot_item.texture = row[raw_header_index["Texture"]]
        loot_item.category = row[raw_header_index["Category"]]
        loot_item.sub_category = row[raw_header_index["SubCategory"]]
        loot_item.description = row[raw_header_index["Description"]]
        loot_item.drop_chance = row[raw_header_index["DropChance"]].to_float()
    
        # Check if category and subcategory exist before storing by category
        if not loot_by_category.has(loot_item.category):
            loot_by_category[loot_item.category] = {}
        if not loot_by_category[loot_item.category].has(loot_item.sub_category):
            loot_by_category[loot_item.category][loot_item.sub_category] = []

        # Store the items for later, both categorized and in a master list
        loot_by_category[loot_item.category][loot_item.sub_category].append(loot_item)
        loot_items.append(loot_item)


func drop_loot_by_category(category, sub_category=null):
    var dropped_loot_items = []
    var eligible_items = []

    # Allow for a null subcategory by building a combined list of eligible items
    if sub_category == null:
        for key in loot_by_category[category].keys():
            eligible_items += loot_by_category[category][key]
    else:
        eligible_items = loot_by_category[category][sub_category]

    # Ask every eligible item to calculate whether it drops or not using its internal logic
    # if it does, add to loot list
    for item in eligible_items:
        if item.didDrop():
            dropped_loot_items.append(item)
    return dropped_loot_items
