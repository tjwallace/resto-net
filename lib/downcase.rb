#encoding:utf-8

module Downcase
  def downcase_utf8(s)
    return nil if s.nil?
    norm = s.downcase
    norm.tr! 'ÁÉÍÓÚ', 'aeiou'
    norm.tr! 'ÀÈÌÒÙ', 'aeiou'
    norm.tr! 'ÄËÏÖÜ', 'aeiou'
    norm.tr! 'ÂÊÎÔÛ', 'aeiou'
    norm.tr! 'áéíóú', 'aeiou'
    norm.tr! 'àèìòù', 'aeiou'
    norm.tr! 'äëïöü', 'aeiou'
    norm.tr! 'âêîôû', 'aeiou'
    norm
  end
end
