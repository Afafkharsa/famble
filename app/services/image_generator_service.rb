require "open-uri"

class ImageGeneratorService
  def self.generate_and_attach(recipe)
    # 1. connect to OpenAI
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    # 2. Generate photo
    prompt_text = "Professional food photography of #{recipe.name}. " \
              "Main ingredients include: #{recipe.keywords}. " \
              "High resolution, 8k, studio lighting, top-down view, delicious look."

    response = client.images.generate(parameters: {
      prompt: prompt_text, size: "512x512"
    })

    # 3. use photo URL
    image_url = response.dig("data", 0, "url")

    if image_url.present?
      # 4. download and attach file into Active Storage
      file = URI.open(image_url)
      recipe.photo.attach(
        io: file,
        filename: "recipe_#{recipe.id}.png",
        content_type: "image/png"
      )
    end
  rescue => e
    Rails.logger.error "AI Image Generation Error: #{e.message}"
  end
end
