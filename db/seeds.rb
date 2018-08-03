def generateRandomGender
    @random_number = rand(10)
    if random_number % 2 == 0
        return "m"
    else
        return "f"
    end
end

def generateRandomLocation(parameter)
    return rand(-parameter .. parameter)
end

5.times do
    Survivor.create({
        name: Faker::Name.name_with_middle,
        age: 20 + rand(20),
        gender: generateRandomGender,
        latitude: generateRandomLocation(90.0),
        longitude: generateRandomLocation(180.0)
    })
end