module StemmingRules # Reminder: FUNCTIONS NEED TO BE EXPORTED TO TEST THEM

#using Stopwords

__VOWELS__ = ("a", "e", "i", "o", "u", "y", "Y")
__STEP0_SUFFIXES__ = r"$'|'s'|'s|'"
__r1__ = ""
__r2__ = ""
__step1a_vowel_found__ = false
__step1b_vowel_found__ = false

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
    #TODO: add stopwords
    if length(word) <=2 return word end

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
function __special_cases(word::String)
    new_word = __prestep(word) # Run the prestep first

    if length(word) <=2 return word end # Always return short words

    # Updates the first region for these special cases
    if startswith(word, r"gener|commun|arsen")
        if startswith(word, r"gener|arsen")
            __r1__ = word[6:end]
        else
            __r1__ = word[7:end]
        end

        for idx in eachindex(word)
            if idx < length(word)
                if string(__r1__[idx+1]) ∉ __VOWELS__ && 
                    string(__r1__[idx]) ∈ __VOWELS__
                    __r2__ = __r1__[idx+2:end]
                    break
                end
            end
        end
    else
        __r1__ = __getR1(word)
        __r2__ = __getR2(__r1__)
    end
    return new_word
end

"""
    __step0(word)

Step 0 in the Snowball algorithm. Removes 's', 's, and ' suffixes.

# Examples
```julia-repl
julia> __step0("caresses")
"caress"
```
"""
function __step0(word::String)
    if length(word) <=2 return word end # Always return short words

    # Check if it is a special case first
    new_word = __special_cases(word)

    if endswith(new_word, __STEP0_SUFFIXES__)
        return replace(new_word, __STEP0_SUFFIXES__ => "", count=1)
    end
    return new_word
end
end