module StemmingRules # Reminder: FUNCTIONS NEED TO BE EXPORTED TO TEST THEM

include("Utils.jl")

using .Stopword
using .Constants

# struct to keep track of variables without giving users direct access
Base.@kwdef mutable struct Controller
    __r1__::String = ""
    __r2__::String = ""
    __step1a_vowel_found__::Bool = false
    __step1b_vowel_found__::Bool = false
end

# Instantiate a Controller to keep track of everything
tracker = Controller()

"""
    __getR1(word, idx=1)

Find the R1 region of a word.

Note: This is a recursive function, so the idx should always be the default.

# Examples
```julia-repl
julia> __getR1("beautiful")
"iful"
```
"""
function __getR1(word::String, idx=1)

    # Stopping criteria
    if string(word[idx]) ∈ __VOWELS__ && string(word[idx+1]) ∉ __VOWELS__
        return word[idx+2:end]
    
    # Base case
    elseif idx+1 >= length(word)
        return ""

    # Keep checking
    else
        __getR1(word, idx+1) 
    end
end

"""
    __getR2(word, idx=1)

Find the R2 region of a word.

Note: This is a recursive function, so the idx should always be the default.

# Examples
```julia-repl
julia> __getR2("beautiful")
"ul"
```
"""
function __getR2(word=r1, idx=1)

    # Stopping criteria
    if idx+1 >= length(word)
        return ""

    # Base case
    elseif string(word[idx]) ∈ __VOWELS__ && string(word[idx+1]) ∉ __VOWELS__
       return word[idx+2:end]
    
    # Keep checking
    else 
        __getR2(word[idx+1:end], idx+1)
    end
end

"""
    __prestep(word)

Converts y to Y if y is preceeded by a vowel.

# Examples
```julia-repl
julia> __getR1("sergey")
"sergeY"
```
"""
function __prestep(word::String)

    # Return short words and Stopwords
    if length(word) <=2 || word ∈ STOPWORDS return word end

    # Checks if there is a vowel followed by a y
    for idx in eachindex(word)
        # Do not go past the end of the word
        if idx < length(word)
            if string(word[idx]) ∈ __VOWELS__ && string(word[idx+1]) == "y"
                return word[1:idx] * "Y" * word[idx+2:end]
            end
        end
    end
    return word
end

"""
    __special_cases(word)

Updates __r1__ and __r2__ for words that start with gener, commun, or arsen
and is only called for its side effects.

# Examples
```julia-repl
julia> __special_cases("communal")
```
"""
function __special_cases(word::String, controller::Controller=tracker)

    # Return short words and Stopwords
    if length(word) <=2 || word ∈ STOPWORDS return word end

    new_word = __prestep(word) # Run the prestep first

    # Updates the first region for these special cases
    if startswith(word, r"gener|commun|arsen")
        if startswith(word, r"gener|arsen")
            controller.__r1__ = word[6:end]
        else
            controller.__r1__ = word[7:end]
        end

        for idx in eachindex(word)
            if idx < length(word)
                if string(controller.__r1__[idx+1]) ∉ __VOWELS__ && 
                    string(controller.__r1__[idx]) ∈ __VOWELS__
                    controller.__r2__ = controller.__r1__[idx+2:end]
                    break
                end
            end
        end
    else
        controller.__r1__ = __getR1(word)
        controller.__r2__ = __getR2(controller.__r1__)
    end
    return new_word
end

"""
    __step0(word)

Step 0 in the Snowball algorithm. Removes 's', 's, and ' suffixes.

# Examples
```julia-repl
julia> __step0("darren's")
"darren"
```
"""
function __step0(word::String)

    # Return short words and Stopwords
    if length(word) <=2 || word ∈ STOPWORDS return word end

    # Check if it is a special case first
    new_word = __special_cases(word)

    if endswith(new_word, __STEP0_SUFFIXES__)
        return replace(new_word, __STEP0_SUFFIXES__ => "", count=1)
    end
    return new_word
end

"""
    __step1a(word)

Step 1a in the Snowball algorithm. Selectively replaces sses, ied, ies, 
s, us, and ss suffixes.

# Examples
```julia-repl
julia> __step1a("caresses")
"caress"
```
"""
function __step1a(word::String, controller::Controller=tracker)

    # Return short words and Stopwords
    if length(word) <=2 || word ∈ STOPWORDS return word end

    # Call __step0
    new_word = __step0(word)

    # Loop through each of the suffixes
    for suffix in __STEP1A_SUFFIXES__

        if endswith(new_word, suffix)
            
            # Check if the word ends with ss
            if suffix == "sses"
                new_word = new_word[1:end-2] # Remove the ss ending

                # Remove the ss ending from __r1__ and __r2__
                controller.__r1__ = controller.__r1__[1:end-2]
                controller.__r2__ = controller.__r2__[1:end-2]

            # Case where the word ends with ies or ied
            elseif suffix ∈ ("ies", "ied")
                
                # Make sure the word is long enough
                if length(new_word[1:end-length(suffix)]) > 1

                    # Remove the suffix from the word and __r1__ and __r2__
                    new_word = new_word[1:end-2]
                    controller.__r1__ = controller.__r1__[1:end-2]
                    controller.__r2__ = controller.__r2__[1:end-2]
                else
                    new_word = new_word[1:end-1]
                    controller.__r1__ = controller.__r1__[1:end-1]
                    controller.__r2__ = controller.__r2__[1:end-1]
                end

            # Check if the word ends with s after checking the other suffixes
            elseif suffix == "s"

                # Loop through each character
                for char in new_word[1:end-2]

                    # Look for a vowel
                    if string(char) ∈ __VOWELS__
                        

                        # Update __step1a_vowel_found__ and break out of the loop
                        controller.__step1a_vowel_found__ = true

                        # Remove the vowel from the word and __r1__ and __r2_
                        controller.__r1__ = controller.__r1__[1:end-1]
                        controller.__r2__ = controller.__r2__[1:end-1]
                        new_word = new_word[1:end-1]
                        break
                    end
                end
            end
        # Break out of the main loop if we have explored every option
        break
        end 
    end
    return new_word
end

function _step1b(string::String, controller::Controller=tracker)

end
end