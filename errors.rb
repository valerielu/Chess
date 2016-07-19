class PieceError < StandardError
  def initialize(message)
    @message = message
  end
end
