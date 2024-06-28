import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class StoryController extends GetxController with WidgetsBindingObserver {
  FlutterTts flutterTts = FlutterTts();
  bool speaking = false;
  double progress = 0.0;
  int lastWordIndex = 0;
  int? getNumId;
  String? getTitle;
  String? getGameId;
  String? getRoleId;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initTts();

    getData();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // Stop TTS when the app enters the background
      flutterTts.stop();
    }
  }

  getData() {
    if (Get.arguments != null) {
      if (Get.arguments["numGrid"] != null &&
              Get.arguments["story_title"] != null &&
              Get.arguments["sendGameId"] != null ||
          Get.arguments["sendRoleId"] != null) {
        getNumId = (Get.arguments["numGrid"]);
        getTitle = (Get.arguments["story_title"]);
        getGameId = (Get.arguments["sendGameId"]);
        getRoleId = (Get.arguments["sendRoleId"]);

        debugPrint('$getNumId');
        debugPrint('$getTitle');
        debugPrint('$getGameId');
        debugPrint('$getRoleId');
      }
    }
  }

  void initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(0.8);
    await flutterTts.setSpeechRate(0.4);
  }

  RxInt currentWordIndex = 0.obs;

  Future<void> speakText(String text) async {
    List<String> words = text.split(' ');
    String textToSpeak = words.sublist(lastWordIndex).join(' ');
    await flutterTts.speak(textToSpeak);
    print('boling ');

    for (int i = lastWordIndex; i < words.length; i++) {
      if (!speaking) break; // Break the loop if speaking is false
      currentWordIndex.value = i;
      await Future.delayed(const Duration(milliseconds: 360));
      // Simulating speech delay
    }

    update();
  }

  // Future<void> speakText(String text) async {
  //   List<String> words = text.split(' ');
  //   String textToSpeak = words.sublist(lastWordIndex).join(' ');
  //   await flutterTts.speak(textToSpeak);
  //   lastWordIndex = words.length;
  //   update(); // Update lastWordIndex
  // }

  Future<void> pauseSpeech() async {
    await flutterTts.pause();
    lastWordIndex = currentWordIndex.value;
    update();
    print('Stop ');
  }

  // stories
  final List<String> storyContent1 = [
    """Once, there was a boy who watched over the village sheep on the hillside. To pass the time, he decided to play a trick. He shouted, “Wolf! Wolf! The wolf is chasing the sheep!”

The villagers heard the cry and rushed to help, but when they got there, they found no wolf. The boy thought it was funny to see their angry faces.

“Don’t say there's a wolf when there isn’t one, boy!” the villagers scolded as they went back home.

Later, the boy played the same trick again. He shouted, “Wolf! Wolf! The wolf is chasing the sheep!” Once more, the villagers came running, only to find no wolf.

They warned him, "Save your calls for when there's a real wolf! Don’t lie about it!” But the boy just laughed as they walked away.

Then, one day, a real wolf came. The boy saw it and shouted for help, “Wolf! Wolf!” But this time, the villagers didn’t believe him. They thought he was tricking them again and didn’t come to help.

When they finally went to check on the boy and the sheep, they found the flock gone, and the boy was crying.

An older man comforted him and said, “Nobody trusts a liar, even when he speaks the truth!"""
  ];
  final List<String> storyContent2 = [
    """
Once upon a time, on a hot summer day, a thirsty crow searched desperately for water in the fields. But sadly, there was no water anywhere to be found.

Then, the crow noticed a pitcher with a little water at the bottom. Excitedly, it flew down to reach the water. But the level was too low, and the crow couldn't drink from it.

Instead of giving up, the clever crow had an idea. It started dropping small pebbles into the pitcher, one by one.

As more pebbles filled the pitcher, the water level began to rise. The crow kept dropping pebbles until the water was high enough for it to drink.

The crow happily drank the water and flew away, feeling grateful for its clever solution to the problem.

This story teaches us the importance of persistence and creativity. It shows that with determination and clever thinking, we can overcome even the most difficult challenges."""
  ];
  final List<String> storyContent3 = [
    """Once there was a king named Midas who did a good deed for a satyr, a nature spirit. In return, Dionysus, the god of wine, granted him a wish.

Midas wished that whatever he touched would turn to gold. Even though Dionysus warned him against it, Midas was adamant, and his wish was granted.

Excited, Midas started touching everything, turning it into gold. But soon, he realized he couldn't eat or drink anything, as it all turned to gold in his hands.

Feeling hungry and desperate, Midas regretted his wish. When his daughter tried to comfort him, she, too, turned into gold.

Midas realized that his golden touch was not a blessing but a curse, and he cried out in despair."""
  ];

  final List<String> storyContent4 = [
    """Once upon a time, a hungry fox set out in search of food. He searched far and wide but found nothing to eat.

Eventually, he came across a farmer's wall. On top of the wall were the biggest, juiciest grapes he had ever seen, ripe and purple.

To reach the grapes, the fox had to jump high. He leaped and tried to catch them in his mouth, but he missed. Again and again, he tried but failed each time.

Feeling disappointed, the fox decided to give up and return home. As he walked away, he muttered, "I'm sure the grapes were sour anyway."""
  ];
  final List<String> storyContent5 = [
    """Once upon a time, in a faraway desert, there lived a proud rose who admired her own beauty. She often made fun of the nearby cactus for being ugly.

Every day, the rose would taunt the cactus, ignoring the advice of other plants who urged her to be kind. But the cactus remained silent, enduring the insults.

One summer, the desert dried up, and there was no water left for the plants. The rose began to wither, her petals losing their vibrant color.

Seeing a sparrow drink water from the cactus, the rose felt ashamed. She asked the cactus for water, and to her surprise, the cactus kindly shared.

Together, they survived the harsh summer, learning the value of friendship and kindness."""
  ];
  final List<String> storyContent6 = [
    """One day, Molly the milkmaid set out with her pails filled with milk. Her task was to milk the cows and then sell the milk at the market. Molly loved to daydream about what she could buy with the money she earned.

As she walked to the market, Molly imagined all the things she wanted to purchase, like a delicious cake and a basket of fresh strawberries. Then, she spotted a chicken along the road and thought, "I'll use today's earnings to buy my own chicken. It will lay eggs, and I can sell both milk and eggs to earn even more money!"

Excitedly, Molly envisioned herself in a fancy dress, making the other milkmaids jealous. She started skipping with joy, forgetting about the milk in her pails. Unfortunately, the milk spilled over, leaving Molly drenched.

Realizing her mistake, Molly sighed, "Oh no! I won't be able to buy a chicken now." Disappointed, she returned home with empty pails.

When Molly's mother saw her, she asked, "What happened to you?"

Molly confessed, "I was too busy dreaming about what I wanted to buy and forgot to watch the milk."

Her mother gently reminded her, "Remember, Molly dear, don't count your chickens before they hatch."""
  ];

  final List<String> storyContent7 = [
    """There was an old owl who made his home in an oak tree. Every day, he observed the happenings around him.

One day, he witnessed a young boy assisting an elderly man in carrying a heavy basket. The next day, he witnessed a young girl shouting at her mother. With each passing day, he spoke less and listened more.

As time went by, the old owl heard many things. He listened to people telling stories and sharing their experiences.

He heard a woman claiming that an elephant had jumped over a fence. He heard a man boasting that he had never made a mistake.

Through it all, the old owl observed how people changed. Some improved, while others worsened. But as for the old owl in the tree, he grew wiser with each passing day."""
  ];
  final List<String> storyContent8 = [
    """Once upon a time, there was a farmer who owned a goose that laid one golden egg every day. This egg provided sufficient money for the farmer and his wife to fulfill their daily needs, and they enjoyed a contented life for a long while.

However, one day, the farmer began to feel greedy. He thought to himself, "Why should we settle for just one egg a day? Why not take them all at once and make a fortune?" Excitedly, he shared his idea with his wife, who unfortunately agreed with him.

The following day, as the goose laid its usual golden egg, the farmer acted swiftly. He grabbed a sharp knife and killed the goose, hoping to find all the golden eggs inside its stomach. But when he opened the goose's stomach, all he found was blood and guts.

Realizing his terrible mistake, the farmer cried over the loss of his precious resource. From that day on, he and his wife became poorer and poorer because of their foolish greed."""
  ];

  final List<String> storyContent13 = [
    """
In a small village nestled between rolling hills, there was a mysterious garden that bloomed with the most extraordinary flowers.
    
The garden was said to be enchanted, and only the bravest souls dared to venture inside. One day, a curious girl named Emily decided to explore the garden. 
     
As she wandered among the flowers, she discovered that each one had its own magical power 
     
– one flower made her invisible, another granted her the ability to fly, and a third could speak to animals. 
     
Emily embarked on a thrilling adventure, using the powers of the garden to help her village and make new friends along the way."""
  ];
  final List<String> storyContent14 = [
    """
In the heart of the forest, there lived a group of animals who loved to race each other. One day, they decided to have a grand race through the forest to determine who was the fastest.

The contenders included a speedy rabbit, a nimble squirrel, a graceful deer, and a determined tortoise. As the race began, the rabbit sprinted ahead, confident of victory.

But the tortoise, slow and steady, kept plodding along. Along the way, the rabbit got distracted, while the tortoise persisted, eventually crossing the finish line first. The animals learned that perseverance and determination were more important than speed."""
  ];
  final List<String> storyContent16 = [
    """
Tucked away in a quiet corner of the city was a toy shop unlike any other. Inside, toys came to life at night, playing games and going on adventures of their own.

One day, a lonely boy named Alex stumbled upon the toy shop and was amazed by what he saw. He befriended a brave knight, a mischievous teddy bear, and a kind-hearted doll who showed him around the magical world of toys.

Together, they embarked on a quest to rescue the toy shop from an evil magician who wanted to steal its magic. With courage and determination, they saved the day and ensured that the magic of the toy shop would live on forever.

These slightly longer stories offer more depth and complexity while still capturing the imagination and wonder of young readers."""
  ];
  final List<String> storyContent15 = [
    """
In a bustling anthill, there lived a tiny ant named Andy.

One day, while gathering food for the colony, he stumbled upon a lost ladybug struggling to find her way home.

Without hesitation, Andy offered to guide her back. With Andy's help, the ladybug safely reunited with her family. Grateful for his kindness, the ladybug told the other insects about Andy's helpful nature. From that day on, whenever someone needed assistance, they knew they could count on Andy. And in return, the ants and their insect friends lived in harmony, knowing that a small act of kindness could make a big difference."""
  ];

// Adventure
//   The Magical Forest Adventure
  final List<String> storyContent17 = [
    """In a village named Eldoria, surrounded by a mysterious forest called the Whispering Woods, lived Lila, a curious girl. Despite warnings about the dangers of the forest, Lila was eager to explore its secrets.

One sunny day, Lila packed some food and a rough map and headed into the forest. With the help of Seraphina, a fairy, and Elion, a wise stag, she journeyed through the forest. They encountered beautiful sights and friendly creatures along the way.

Deep in the woods, they found a hidden place with an old chest. Inside was a glowing amulet, filled with the magic of the forest. Seraphina told Lila that she was now the guardian of the forest, entrusted with its protection.

When Lila returned to the village, she shared her adventure with everyone. Inspired by her bravery, the villagers promised to respect and care for the forest. With the amulet, Lila vowed to keep the Whispering Woods safe forever, becoming a hero in the eyes of her village."""
  ];

  final List<String> storyContent18 = [
    """Underneath the ocean, there's a magical place called the Underwater Kingdom. It's full of beautiful coral castles and colorful fish. Queen Mariana rules the kingdom and keeps everything peaceful.

Ethan, a brave explorer, decides to visit this kingdom. He meets friendly creatures along the way and learns about the secrets of the deep sea.

As Ethan explores more, he realizes the kingdom is a special place where everyone gets along. Queen Mariana admires Ethan for his bravery and kindness.

The story of Ethan and the Underwater Kingdom spreads, showing how courage and friendship can make a difference in the deep blue sea."""
  ];

  final List<String> storyContent19 = [
    """In a small town, twins Alex and Emma stumbled upon an old watch that could travel through time. Curious and adventurous, they embarked on extraordinary journeys to different eras.

Their first adventure took them to ancient Egypt, where they witnessed the construction of the pyramids and befriended pharaohs. In medieval Europe, they jousted with knights and attended grand feasts.

But time travel wasn't all fun and games. They faced dangers, like narrowly escaping a pirate attack in the Caribbean and outsmarting villains in the Wild West.

Despite the risks, Alex and Emma learned valuable lessons about history and themselves. They realized that even small actions could change the course of time.

Their last adventure took them back home, where they returned the watch to its rightful place. Though their time-traveling days were over, the memories of their adventures would last a lifetime.

As they grew older, Alex and Emma cherished their experiences, knowing that the greatest adventure of all was the bond they shared as twins, no matter where—or when—they traveled."""
  ];

  final List<String> storyContent20 = [
    """In a faraway land, siblings Max and Lily embarked on an exciting quest to find the Dragon's Cave. Armed with a map and their bravery, they ventured into the unknown.

Through dense forests and over rugged mountains, they journeyed, facing challenges along the way. Yet, their determination never wavered.

At last, they reached the cave's entrance, where a fearsome dragon guarded its treasures. With quick thinking and kindness, they befriended the dragon, learning of its loneliness and longing for companionship.

Together, they explored the cave's depths, discovering glittering treasures and ancient artifacts. But the greatest treasure of all was the friendship they found with the dragon.

As they bid farewell to their newfound friend, Max and Lily returned home, their hearts full of adventure and wonder. Though they may never forget their journey to the Dragon's Cave, they knew that the greatest treasure was the bond they shared as siblings."""
  ];

  // comedy

  final List<String> storyContent21 = [
    """"The Silly Circus Catastrophe" tells the story of a circus in trouble. The circus is supposed to be a place of fun and joy, but everything goes wrong one day. The clowns lose their big red noses, the acrobats can't do their flips properly, and the tightrope walker keeps falling off. The animals escape from their cages and cause chaos under the big top.

The circus owner, Mr. Bobo, is frantic. He tries to fix everything, but it just gets sillier and sillier. Finally, he gathers all the performers together and they come up with a plan. They decide to turn the chaos into a new show called "The Silly Circus Catastrophe."

Instead of trying to be perfect, they embrace the silliness and make the audience laugh even harder than before. The audience loves it! They cheer and clap as the performers tumble, juggle, and dance their way through the catastrophe.

In the end, the circus is saved by turning their misfortune into a funny and entertaining show. They learn that sometimes it's okay to laugh at ourselves and make the best of a bad situation."""
  ];

  final List<String> storyContent22 = [
    """
"The Pizza Parlor Pandemonium" is about a crazy day at a pizza restaurant. It's usually a calm place where people come to eat delicious pizza, but today is different. Everything that could go wrong does go wrong.

First, the oven breaks down, so they can't bake any pizzas. Then, the delivery guy gets lost and delivers pizzas to the wrong houses. Customers start complaining, and some even leave without paying. To make matters worse, the cheese and toppings run out, leaving only plain dough.

The manager, Mrs. Pepperoni, tries to keep things under control, but it's chaos. People are shouting, pizzas are burning, and there's sauce splattered everywhere. Just when it seems like things can't get any worse, a big group of hungry tourists walks in.

Instead of panicking, Mrs. Pepperoni and her team come up with a plan. They start making funny-shaped pizzas with whatever ingredients they have left. The customers find it hilarious and join in the fun, tossing dough in the air and laughing.

In the end, the day turns into a memorable experience for everyone. The pizza parlor may have had pandemonium, but they turned it into a party with laughter and creativity."""
  ];

  final List<String> storyContent23 = [
    """
"The Giggle Ghost Mystery" is a story about a strange happening in a little town. Every night, giggling sounds echo through the streets, scaring the residents. People say it's the Giggle Ghost, but no one knows for sure.

A group of curious kids decides to investigate. They sneak out after dark armed with flashlights and bravery. As they wander the streets, they hear the giggles growing louder. The kids follow the sound to an old, abandoned house at the edge of town.

Inside, they find nothing but dust and cobwebs. But then, they hear the giggles coming from the attic. With trembling hands, they climb the creaky stairs. In the attic, they discover an old music box covered in dust.

When they wind it up, the music starts playing a silly tune, and the giggling echoes around them. They realize that the "Giggle Ghost" is just a trick played by the wind blowing through the broken windows, making the music box play and creating the eerie laughter.

Relieved and laughing at themselves, the kids solve the mystery and return home, happy to have uncovered the truth behind the spooky sounds."""
  ];

  final List<String> storyContent24 = [
    """"The Daring Dinosaur Dilemma" is an exciting tale about a group of friends who encounter a big problem. One day, while exploring in the forest, they stumble upon a lost baby dinosaur! They name her Daisy and decide to take care of her, but keeping a dinosaur hidden is not easy.

Word spreads quickly, and soon, everyone in town knows about Daisy. The friends realize they have a dilemma: they want to keep Daisy safe, but they don't want to cause a panic. They hatch a plan to hide Daisy in a secret cave in the woods.

As they try to keep Daisy hidden, they face many challenges. People start searching for the dinosaur, and the friends must outsmart them at every turn. They use disguises, distractions, and clever tricks to keep Daisy safe.

But keeping a dinosaur hidden is harder than they thought. Daisy is curious and playful, and she keeps getting into mischief. Despite their best efforts, they struggle to keep her out of trouble.

In the end, the friends realize that Daisy belongs in the wild, and they set her free. Although they'll miss her, they know it's the right thing to do. And they'll always remember their daring adventure with Daisy the dinosaur."""
  ];

  // nurserPoems  nursery - lkg

  final List<String> nurserPoems1 = [
    """I made myself a snowball
As perfect as could be.
I thought I'd keep it as a pet
And let it sleep with me.
I made it some pajamas
And a pillow for its head.
Then last night it ran away,
But first it wet the bed."""
  ];
  final List<String> nurserPoems2 = [
    """How doth the little crocodile
Improve his shining tail,
And pour the waters of the Nile
On every golden scale!
How cheerfully he seems to grin,
How neatly spreads his claws,
And welcomes little fishes in,
With gently smiling jaws!"""
  ];
  final List<String> nurserPoems3 = [
    """When I was One,
I had just begun.
When I was Two,
I was nearly new.
When I was Three
I was hardly me.
When I was Four,
I was not much more.
When I was Five,
I was just alive.
But now I am Six,
I'm as clever as clever,
So I think I'll be six now for ever and ever."""
  ];
  final List<String> nurserPoems4 = [
    """Nobody knows the rabbit's nose,
the way it twitches,
the way it goes.
Nobody knows the rabbit's ears,
the way it listens,
the way it hears.
Nobody knows the rabbit's toes,
the way they hop the highs,
the way they bounce the lows.
I know the rabbit's eyes,
the way they look,
the way they despise."""
  ];

  //  ukg to 2nd
  final List<String> nurserPoems5 = [
    """Mary had a little lamb,
Its fleece was white as snow;
And everywhere that Mary went,
The lamb was sure to go.

It followed her to school one day,
Which was against the rule;
It made the children laugh and play
To see a lamb at school.

And so the teacher turned it out,
But still it lingered near,
And waited patiently about,
Till Mary did appear.

"Why does the lamb love Mary so?"
The eager children cry;
"Why, Mary loves the lamb, you know,"
The teacher did reply.
"""
  ];
  final List<String> nurserPoems6 = [
    """Rain, rain, go away,
Come again another day;
Little Johnny wants to play,
Rain, rain, go away.

Rain, rain, go to Spain,
Never show your face again.
"""
  ];
  final List<String> nurserPoems7 = [
    """I'm a little teapot, short and stout,
Here is my handle, here is my spout;
When I get all steamed up, hear me shout,
"Tip me over and pour me out!"

I'm a clever teapot, yes, it's true,
Here let me show you what I can do;
I can change my handle and my spout,
Just tip me over and pour me out!
"""
  ];
  final List<String> nurserPoems8 = [
    """Baa, baa, black sheep, have you any wool?
Yes, sir, yes, sir, three bags full;
One for the master, one for the dame,
And one for the little boy who lives down the lane.

Baa, baa, black sheep, have you any wool?
Yes, sir, yes, sir, three bags full;
One for the master, one for the dame,
And one for the little boy who lives down the lane.
"""
  ];

  //  2nd to 5th
  final List<String> nurserPoems9 = [
    """Whose woods these are I think I know.
His house is in the village though;
He will not see me stopping here
To watch his woods fill up with snow.

My little horse must think it queer
To stop without a farmhouse near
Between the woods and frozen lake
The darkest evening of the year.

He gives his harness bells a shake
To ask if there is some mistake.
The only other sound’s the sweep
Of easy wind and downy flake.

The woods are lovely, dark and deep,
But I have promises to keep,
And miles to go before I sleep,
And miles to go before I sleep.
"""
  ];
  final List<String> nurserPoems10 = [
    """He clasps the crag with crooked hands;
Close to the sun in lonely lands,
Ring’d with the azure world, he stands.

The wrinkled sea beneath him crawls;
He watches from his mountain walls,
And like a thunderbolt he falls.
"""
  ];
  final List<String> nurserPoems11 = [
    """I wandered lonely as a cloud
That floats on high o'er vales and hills,
When all at once I saw a crowd,
A host, of golden daffodils;
Beside the lake, beneath the trees,
Fluttering and dancing in the breeze.

Continuous as the stars that shine
And twinkle on the milky way,
They stretched in never-ending line
Along the margin of a bay:
Ten thousand saw I at a glance,
Tossing their heads in sprightly dance.

The waves beside them danced; but they
Out-did the sparkling waves in glee:
A poet could not but be gay,
In such a jocund company:
I gazed—and gazed—but little thought
What wealth the show to me had brought:

For oft, when on my couch I lie
In vacant or in pensive mood,
They flash upon that inward eye
Which is the bliss of solitude;
And then my heart with pleasure fills,
And dances with the daffodils.
"""
  ];
  final List<String> nurserPoems12 = [
    """Some say the world will end in fire,
Some say in ice.
From what I’ve tasted of desire
I hold with those who favor fire.
But if it had to perish twice,
I think I know enough of hate
To say that for destruction ice
Is also great
And would suffice.
"""
  ];

  @override
  void dispose() async {
    await flutterTts.stop();

    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
