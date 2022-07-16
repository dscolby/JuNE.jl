function _getR1(word::String)
    idx = 0 # The index of the first vowel
    found_vowel = false

    # Loop through every character
    for char in word
        idx += 1 # Update the index

        # Make sure to stop at the end of the word
        if idx < length(word)

            # Checks if character is vowel and next character is not
            if string(char) ∈ VOWELS
                found_vowel = true

                if found_vowel && string(char) ∉ VOWELS
                    return word[idx:end]
                end
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

function _rule1b(str::String)
    r1 = _getR1(str) # The R1 region of the word

    # If there is no R1 region, return the original word
    if r1 == "" return str end

    # Check if the R1 region has an eed or eedly+ ending
    if occursin(r"eed|eedly|eedly+[a-zA-Z]*", r1)
        return reverse(replace(reverse(str), 
            r"d|yld|[a-zA-Z]+yld" => "", count=1))
    end

    # Check if the word ends with ed, edly+, or ing+
    if endswith(str, r"ed|edly|edly+[a-zA-Z]*|ing|ing+[a-zA-Z]*")

        # Removes those suffixes
        nosuffix = replace(str,  r"ed|edly|ing" => "", count=1)

        # Check if there is a vowel before the suffix
        if occursin(r"[aeiouy]", nosuffix)
            if endswith(nosuffix, r"at|bl|iz")
                return nosuffix * "e"
            end
        end
    end
    return nosuffix
end
broadcast(_rule1b, ("speed", "repeated", "luxuriated","luxuriating"))