from os import getenv
from google.cloud import storage
from base64 import b64decode
from PIL import Image
from io import BytesIO
from facenet_pytorch import InceptionResnetV1
from os.path import isfile, join, expanduser, isdir
from json import JSONEncoder
from numpy import squeeze, float32
import pathlib
from torchvision.transforms.functional import to_tensor


def run_face_model(req):
    if "application/json" not in req.content_type:
        return json_encoder.encode({"result": None, "message": "Bad content type"})
    data = req.get_json()
    if data['image'] is None:
        return json_encoder.encode({"result": None, "message": "No image provided"})
    prep_img = prepare_image(data['image'])
    prediction = model(prep_img.unsqueeze(0))
    prediction_list = squeeze(prediction.data.cpu().numpy(), axis=0).tolist()
    return json_encoder.encode({"result": prediction_list, "message": None})


def get_torch_home():
    return expanduser(getenv(
        'TORCH_HOME',
        join(getenv('XDG_CACHE_HOME', '~/.cache'), 'torch')
    ))


def model_dir(file):
    return join(join(get_torch_home(), 'checkpoints'), file)


client = storage.Client()

bucket = client.get_bucket("face-app-c3aee.appspot.com")
if not isdir(model_dir('')):
    pathlib.Path(model_dir('')).mkdir(parents=True, exist_ok=True)

if not isfile(model_dir("vggface2_DG3kwML46X.pt")):
    bucket.blob('face_model/vggface2_DG3kwML46X.pt') \
        .download_to_filename(model_dir("vggface2_DG3kwML46X.pt"))

if not isfile(model_dir("vggface2_G5aNV2VSMn.pt")):
    bucket.blob('face_model/vggface2_G5aNV2VSMn.pt') \
        .download_to_filename(model_dir("vggface2_G5aNV2VSMn.pt"))

model: InceptionResnetV1 = InceptionResnetV1(pretrained="vggface2")
model.eval()
json_encoder = JSONEncoder()


def prepare_image(image_string):
    image_data = b64decode(image_string)
    image: Image = Image.open(BytesIO(image_data)).resize((160, 160), 2)
    return prewhiten(to_tensor(float32(image)))


def prewhiten(x):
    mean = x.mean()
    std = x.std()
    std_adj = std.clamp(min=1.0 / (float(x.numel()) ** 0.5))
    y = (x - mean) / std_adj
    return y
