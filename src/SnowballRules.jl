module StemmingRules # Reminder: FUNCTIONS NEED TO BE EXPORTED TO TEST THEM

function _getR1(str)
    vowels = ("a", "e", "i", "o", "u", "y")
    idx = 0 # The index of the first vowel

    # Loop through every character
    for char in str
        idx += 1 # Update the index

        # make sure to stop at the end of the word
        if idx < length(str)

            # Checks if character is vowel and next character is not
            if string(char) ∈ vowels && string(str[idx+1]) ∉ vowels
                return str[idx+2:end] # R1 region
            end
        end
    end
    return ""
end

function _rule0(str::String)
    if endswith(str, r"'s'|'s|'")
        return replace(str, r"$'s'|'s|'" => "", count=2)
    end
end

function _rule1(str::String)

    # Make words like caresses into their base words
    endswith(str, r"sses") ? str = str[1:end-2] : str

    # Replace words that end in ies or ied with their base words
    if endswith(str, r"ied|ies")
        # Cuts off the es or ed if the word is longer than four letters
        if length(str) > 4
            return str[1:end-2]
        # Only removes the s on shorter words like ties
        else
            return str[1:end-1]
        end
    end

    # If a string ends in an s and has a vowel not immediately before
    # the s, removes the s: ei gaps -> gap
    if endswith(str, r"[b-df-hj-np-rt-v-z]+s") && 
        occursin(r"[aeiouy]", str[1:end-2])
        str = str[1:end-1]
    end

    return str
end

broadcast(_getR1, ("beautiful", "beauty", "beau"))
end