from bs4 import BeautifulSoup
from urllib.request import urlopen
from json import JSONEncoder
import json
import re

BASE_URL = "http://www.dbs-cardgame.com/"


class MyEncoder(JSONEncoder):

    def default(self, o):
        return o.__dict__


class Card:
    pass


class Skill:

    def __init__(self):
        self.keywords = []


class EnergyCost:
    pass


def main():
    write_cards(get_cards(["428001", "428301", "428901"]))


def get_cards(categories):
    return flatten([scrape(c) for c in categories])


def scrape(category):
    soup = BeautifulSoup(
        urlopen(BASE_URL + "cardlist/?search=true&category=" + category), "html.parser")
    return [parse_card(c) for c in soup(class_="cardListCol")]


def parse_card(card_html):
    """
    Parses out all the data for each type of card
    """
    card_type = card_html.select(".typeCol dd")[0].string.upper()

    card = {
        "LEADER": parse_leader,
        "BATTLE": parse_battle,
        "EXTRA": parse_extra
    }[card_type](card_html)

    # shared fields
    card.type = card_type.lower()
    card.number = card_html.find(class_="cardNumber").string
    card.name = card_html.find(class_="cardName").string
    card.image_url = extract_image_url(card_html)
    card.rarity = extract_rarity(card_html)
    card.series = extract_series(card_html)
    card.color = extract_data(card_html, "colorCol").lower()
    card.skills = extract_skills(card_html)

    return card


def parse_leader(html):
    card = Card()
    card.front = "cardFront" in html["class"]
    card.power = extract_power(html)
    card.character = extract_character(html)
    card.special_trait = extract_special_trait(html)
    card.era = extract_era(html)
    return card


def parse_battle(html):
    card = Card()
    card.power = extract_power(html)
    card.character = extract_character(html)
    card.special_trait = extract_special_trait(html)
    card.era = extract_era(html)
    card.combo_energy = int(extract_data(html, "comboEnergyCol"))
    card.combo_power = int(extract_data(html, "comboPowerCol"))
    card.energy_cost = extract_energy_cost(html)
    return card


def parse_extra(html):
    card = Card()
    card.energy_cost = extract_energy_cost(html)
    return card


def parse_skill(html):
    skill = Skill()

    soup = BeautifulSoup(html, "html.parser")
    if soup.find(class_='skillTextBall'):
        skill.energy_cost = [parse_cost(i)
                             for i in soup.find_all(class_='skillTextBall')]

    if soup.find(class_='skillText'):
        skill.keywords = [parse_keyword(i).lower()
                          for i in soup.find_all(class_='skillText')]

    while soup.find(class_='skillText'):
        img = soup.find(class_='skillText')
        img.replace_with('[' + parse_keyword(img).upper() + ']')

    skill.text = soup.get_text().strip().replace(u': ', '').replace(
        u'\uff1c', '<').replace(u'\uff1e', '>').replace('\n', '').replace(u'\u300a', '<<').replace(u'\u300b', '>>').replace(u'\u2010', '-').replace(u'\u226a', '<<').replace(u'\u226b', '>>')
    skill.text = re.sub(r' +', ' ', skill.text)

    # Handle weirdness when the website doesn't use an image for the keyword
    if u'\u3010' in skill.text:
        start, end = skill.text.find(u'\u3010'), skill.text.find(u'\u3011')
        if start < end:
            keyword = skill.text[start + 1: end]
            skill.keywords.append(keyword.strip().lower())
            skill.text = skill.text.replace(
                u'\u3010' + keyword + u'\u3011', u'\u3010' + keyword.strip().upper() + u'\u3011')
        skill.text = skill.text.replace(u'\u3010', '[').replace(u'\u3011', ']')

    return skill


def parse_cost(img):
    img_file = img['src'].split('/')[-1].lower()
    return {
        "red_ball.png": "red",
        "blue_ball.png": "blue",
        "green_ball.png": "green",
        "yellow_ball.png": "yellow",
        "one.png": "1",
        "two.png": "2",
        "three.png": "3",
        "four.png": "4",
        "six.png": "6",
        "sixteen.png": "16"
    }[img_file]


def parse_keyword(img):
    return img['alt'].strip().replace(' ', '-')


def extract_image_url(html):
    """
    Replaces the relative path image with the full path to the image
    for future downloading/referencing
    """
    tags = html.select(".cardimg img")
    url = tags[0]["src"][3:] if len(tags) > 0 else ""
    return BASE_URL + url


def extract_rarity(html):
    """
    Expected format for rarity
        "Common[C]"
        "Special Rare[SR]"
    """
    rarity = extract_data(html, "rarityCol")

    # the website doesn't consistently use one type of bracket
    start = rarity.find("[") if "[" in rarity else rarity.find(u"\uff3b")
    end = rarity.find("]") if "]" in rarity else rarity.find(u"\uff3d")

    return rarity[start + 1:end] if start >= 0 and start < end else rarity


def extract_series(html):
    """
    Extracts the series the card belongs to and removes the <br>
    """
    contents = html.select(".seriesCol dd")[0].contents
    return (contents[0].strip() + ": " + contents[2].strip() if len(contents) > 2 else contents[0].strip()).replace(u'\uff5e', '~')


def extract_power(html):
    return int(extract_data(html, "powerCol"))


def extract_character(html):
    return extract_data(html, "characterCol")


def extract_special_trait(html):
    return extract_data(html, "specialTraitCol")


def extract_era(html):
    return extract_data(html, "eraCol").replace(u'\u2018', '\'').replace(u'\u2019', '\'')


def extract_skills(html):
    skills = html.select(".skillCol dd")[0].prettify().split('<br/>')
    return [parse_skill(s) for s in skills]


def extract_energy_cost(html):
    cost = EnergyCost()
    energy_html = html.select('.energyCol dd')[0]

    cost.total = int(energy_html.get_text().replace(
        '(', '').replace(')', '').replace('-', '').strip())
    cost.colors = []
    while energy_html.find(class_='colorCostBall'):
        img = energy_html.find(class_='colorCostBall')
        cost.colors.append(parse_cost(img))
        img.replace_with('')

    return cost


def flatten(lst):
    """
    Reduces a list of lists to a list of items
    """
    return [item for sublist in lst for item in sublist]


def extract_data(html, cls):
    """
    Extracts a the data for a common layout structure
    """
    cls = cls if "." in cls else "." + cls
    tags = html.select(cls + " dd")
    return tags[0].string.strip()


def write_cards(cards):
    """
    Saves the cards json to a cards.json file
    """
    json_str = json.dumps(cards, cls=MyEncoder)
    f = open("cards.json", "w")
    f.write(json_str)
    f.close()
    print(json_str)

if __name__ == "__main__":
    main()
