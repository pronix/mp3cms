Допустим 'обновляем индексы Sphinx' do
  # Update all indexes
  ThinkingSphinx::Test.index
  sleep(2) # Wait for Sphinx to catch up
end

