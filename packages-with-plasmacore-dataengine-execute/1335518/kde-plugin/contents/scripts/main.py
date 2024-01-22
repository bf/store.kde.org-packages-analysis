#!/usr/bin/python3
from PIL import Image, ImageDraw
import click, importlib, os, json, sys

from generators import plain
from utils import color_util

def _merge_dicts(list_dicts):
    merged = {}
    for dic in list_dicts:
        for k, v in dic.items():
            merged[k] = v
    return merged
def is_dependencies_installed():
    base_path = os.path.dirname(os.path.realpath(__file__))
    available_generators = {}
    for file in os.listdir(os.path.join(base_path, "generators")):
        if "__init__" in file or "__pycache__" in file:
            continue
        if "disabled_" in file:
            continue
        gen_name = file.replace(".py", "")
        available_generators[gen_name] = {}
        try:
            gen = importlib.import_module(f"generators.{gen_name}")
            gen_class = getattr(gen, gen_name)
            _ = gen_class()
        except Exception as e:
            print(e)
            return 1
    return 0

def print_json_settings():
    base_path = os.path.dirname(os.path.realpath(__file__))
    available_generators = {}
    for file in os.listdir(os.path.join(base_path, "generators")):
        if "__init__" in file or "__pycache__" in file:
            continue
        if "disabled_" in file:
            continue
        gen_name = file.replace(".py", "")
        available_generators[gen_name] = {}
        try:
            gen = importlib.import_module(f"generators.{gen_name}")
            gen_class = getattr(gen, gen_name)
            gen_obj = gen_class()
            if "print_options" in dir(gen_obj):
                merged = _merge_dicts(gen_obj.print_options())
                for k, values in merged.items():
                    for kk, v in values.items():
                        if kk is "type":
                            if hasattr(v, "__name__"):
                                merged[k][kk] = v.__name__
                            else:
                                merged[k][kk] = v
                available_generators[gen_name] = merged
        except Exception as e:
            print(e)
    return json.dumps(available_generators)

@click.command()
@click.option("-s", "--size", help="resolution, in this format: 800x600", default="1920x1080")
@click.option("-o", "--out-filename", default="output.png", help="The output filename, i.e. ~/Desktop/out.png")
@click.option("-g", "--generator", default="plain", help="Generator name, see the 'generator' folder for examples of this, some examples:\n- plain\n- lines\n- grid")
@click.option("-p", "--param", multiple=True, help="Additional parameters for generators")
@click.option("-a", "--validate", is_flag=True, help="Validate that all dependencies are installed, used for integration")
@click.help_option('-h')
@click.option("-j", "--json-export", is_flag=True, help="Display all available generators and their config, in json format")
@click.option("--disable-supersampling", is_flag=True, help="Makes generation faster, at the loss of quality")
def main(size, out_filename, generator, param, validate, json_export, disable_supersampling):
    
    if validate:
        sys.exit(is_dependencies_installed())
    elif json_export:
        print(print_json_settings())
    else:
        w, h = size.split("x")
        w = int(w)
        h = int(h)
        wo = w
        ho = h
        if not disable_supersampling:
            w *= 2
            h *= 2

        if w > 10000:
            w = 10000
        if h > 10000:
            h = 10000

        print(f"Generating a wallpaper with size {w}x{h}")

        img = Image.new('RGB', (w, h), color=(0, 0, 0))

        options = {}
        for par in param:
            k, v = par.split("=")
            options[k] = v

        gen = importlib.import_module(f"generators.{generator}")
        gen_class = getattr(gen, generator)
        gen_obj = gen_class()

        ignored = {}
        if "print_options" in dir(gen_obj):
            print("Setting the following options: ")
            merged = _merge_dicts(gen_obj.print_options())
            for key, values in merged.items():
                safe_name = key.replace("-", "_")
                class_type = values["type"]
                simple_type = not class_type in [str] and not class_type.__class__.__name__ == "str"
                
                target_value = ""
                if "default" in values:
                    target_value = values["default"]
                if key in options:
                    print(f"  {safe_name}:{options[key]}")
                    target_value = options[key]

                if simple_type:
                    setattr(gen_obj, safe_name, class_type(target_value))
                else:
                    if class_type == "color":
                        if target_value == "random":
                            target_value = color_util.random_hex()
                    setattr(gen_obj, safe_name, target_value)

            for k, v in options.items():
                if k not in merged:
                    ignored[k] = options[k]
        if ignored:
            print("The following options were passed but unused:")
            for key, value in ignored.items():
                print(f"   {key}:{value}")
        img = gen_obj.generate(img, options)

        if not disable_supersampling:
            img = img.resize((wo, ho), resample=Image.LANCZOS)
        img.save(out_filename)

        print(f"Saved as {out_filename}")

if __name__ == '__main__':
    main()