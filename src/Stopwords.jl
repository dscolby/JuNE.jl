"""
Contains a set of stopwords including contractions such as "don't."
The stopwords are the same ones used in the SpaCy library for Python:
https://github.com/explosion/spaCy. The contractions are based on the
list of contractions used by Wikipedia: Manual of Style:
https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Abbreviations.
Note: If using these stopwords oustide of this package, the uprocessed
text that will have stopwords removed should not contain apostrophes.
"""
module Stopword

export STOPWORDS

const NOTOKENS = """
a about above across after afterwards again against all almost alone 
along already also although always am among amongst amount an and 
another any anyhow anyone anything anyway anywhere are around as at
back be became because become becomes becoming been before beforehand 
behind being below beside besides between beyond both bottom but by call 
can cannot ca could did do does doing done down due during each eight 
either eleven else elsewhere empty enough even ever every everyone 
everything everywhere except few fifteen fifty first five for former 
formerly forty four from front full further get give go had has have he 
hence her here hereafter hereby herein hereupon hers herself him himself 
his how however hundred i if in indeed into is it its itself keep last 
latter latterly least less just made make many may me meanwhile might 
mine more moreover most mostly move much must my myself name namely 
neither never nevertheless next nine no nobody none noone nor not
nothing now nowhere of off often on once one only onto or other others 
otherwise our ours ourselves out over own part per perhaps please put
quite rather re really regarding same say see seem seemed seeming seems 
serious several she should show side since six sixty so some somehow 
someone something sometime sometimes somewhere still such take ten than 
that the their them themselves then thence there thereafter thereby 
therefore therein thereupon these they third this those though three
through throughout thru thus to together too top toward towards twelve 
twenty two under until up unless upon us used using various very very 
via was we well were what whatever when whence whenever where whereafter 
whereas whereby wherein whereupon wherever whether which while whither 
who whoever whole whom whose why will with within without would yet you 
your yours yourself yourselves
"""

const CONTRACTIONS = """
ain't amn't	'n' arencha aren't 'bout can't cap'n 'cause 'cept could've 
couldn't couldn't've cuppa	daren't	daresn't dasn't	didn't doesn't don't 
dunno d'ye d'ya e'en e'er 'em everybody's everyone's finna fix'n' 
fo'c'sle 'gainst g'day gimme giv'n gi'z gonna gon't gotta hadn't had've 
hasn't haven't he'd he'll helluva he's here's how'd howdy how'll how're 
how's i'd i'd've i'd'nt i'd'nt've if'n i'll i'm imma i'm'o innit ion 
i've isn't it'd	it'll it's idunno kinda let's loven't ma'am mayn't 
may've methinks mightn't might've mustn't mustn't've must've 'neath 
needn't	nal ne'er o'clock o'er ol' ought've	oughtn't oughtn't've 'round	
's shalln't	shan't she'd she'll	she's should've	shouldn't shouldn't've 
somebody's someone's something's so're so's so've that'll that're that's	
that'd there'd there'll	there're there's these're these've they'd 
they'll	they're	they've	this's those're those've 'thout 'til 'tis to've 
'twas 'tween 'twere w'all w'at wanna wasn't	we'd we'd've we'll we're	
we've weren't whatcha what'd what'll what're what's what've	when's
where'd	where'll where're where's where've which'd which'll	which're	
which's	which've who'd who'd've	who'll who're who's	who've why'd why're	
why's willn't won't	wonnot would've	wouldn't wouldn't've y'ain't y'all 
y'all'd've y'all'd'n't've y'all're y'all'ren't y'at yes'm y'know yessir	
you'd you'll you're	you've when'd willn't
"""

const stopwords = split(NOTOKENS) # Tokenize
const contractions =  split(replace(CONTRACTIONS, "'" => ""))

const STOPWORDS = [stopwords; contractions]

end